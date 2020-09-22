//
//  PaymentCoordinator.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/27/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

/// Coordinator that manages the initialization of the PaymentHistoryViewController
class PaymentCoordinator: FlowCoordinator {
    private(set) lazy var rootVC = UINavigationController(rootViewController: paymentHistoryVC)
    private lazy var paymentHistoryVC = configure(PaymentHistoryViewController()) {
        $0.navigationItem.setRightBarButton(
            UIBarButtonItem(
                image: .creditCard,
                style: .plain,
                target: self,
                action: #selector(makePaymentTapped(_:))),
            animated: true)
    }
    private var makePaymentNav: UINavigationController?

    let paymentController: PaymentController

    init(user: User, dataProvider: PaymentDataProvider) {
        self.paymentController = PaymentController(user: user,
                                                   dataProvider: dataProvider)
        paymentHistoryVC.paymentController = paymentController
    }

    /// Starts the PaymentHistoryViewController
    func start() {
        let payment = UIImage(
            systemName: "dollarsign.circle",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        )
        rootVC.tabBarItem = UITabBarItem(title: "Payments", image: payment, tag: 0)
    }

    @objc private func makePaymentTapped(_ sender: Any?) {
        guard let property: Property = {
            if (paymentController.user.properties?.count ?? 0) > 1 {
                return UserDefaults.standard.selectedProperty(forUser: paymentController.user)
            } else {
                return paymentController.user.properties?.first
            }
        }() else {
            return rootVC.presentAlert(
                for: ErrorMessage(
                    title: "Cannot get next payment for all properties.",
                    message: "Please select a single property and try again."))
        }
        rootVC.present(LoadingViewController(loadingText: "Loading payment"), animated: true) { [weak self] in
            self?.paymentController.fetchNextPayment(forPropertyID: property.id) { result in
                DispatchQueue.main.async {
                    self?.rootVC.dismiss(animated: true, completion: {
                        guard let self = self else { return }
                        switch result {
                        case .success(let payment):
                            let makePaymentVC = MakePaymentViewController(
                                payment: payment,
                                paymentController: self.paymentController,
                                stripeController: nil)
                            makePaymentVC.delegate = self
                            self.makePaymentNav = UINavigationController(
                                rootViewController: makePaymentVC)
                            self.makePaymentNav!.modalPresentationStyle = .fullScreen
                            self.rootVC.present(
                                self.makePaymentNav!,
                                animated: true,
                                completion: nil)
                        case .failure(let error):
                            self.rootVC.presentAlert(for: error)
                        }
                    })
                }
            }
        }
    }
}

extension PaymentCoordinator: MakePaymentDelegate {
    func cancelPayment() {
        guard makePaymentNav != nil else { return }
        rootVC.dismiss(animated: true, completion: nil)
    }
}
