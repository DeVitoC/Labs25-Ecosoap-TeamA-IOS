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
    private(set) lazy var rootVC = UINavigationController(rootViewController: paymentVC)
    private lazy var paymentVC = configure(PaymentHistoryViewController()) {
        $0.navigationItem.setRightBarButton(
            UIBarButtonItem(
                image: .creditCard,
                style: .plain,
                target: self,
                action: #selector(makePaymentTapped(_:))),
            animated: true)
    }
    let paymentController: PaymentController

    init(user: User, dataProvider: PaymentDataProvider) {
        self.paymentController = PaymentController(user: user,
                                                   dataProvider: dataProvider)
        paymentVC.paymentController = paymentController
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
        guard let property = UserDefaults.standard.selectedProperty(forUser: paymentController.user) else {
            return rootVC.presentAlert(
                for: ErrorMessage(
                    title: "Cannot get next payment for all properties.",
                    message: "Please select a single property and try again."))
        }
        rootVC.present(LoadingViewController(), animated: true) { [weak self] in
            self?.paymentController.fetchNextPayment(forPropertyID: property.id) { result in
                self?.rootVC.dismiss(animated: true, completion: {
                    guard let self = self else { return }
                    switch result {
                    case .success(let payment):
                        self.rootVC.present(
                            MakePaymentViewController(
                                payment: payment,
                                paymentController: self.paymentController,
                                stripeController: nil),
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
