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

    init(user: User, dataProvider: PaymentDataProvider) {
        paymentVC.paymentController = PaymentController(user: user,
                                                        dataProvider: dataProvider)
    }

    /// Starts the PaymentHistoryViewController
    func start() {
        let payment = UIImage(
            systemName: "dollarsign.circle",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        )
        rootVC.tabBarItem = UITabBarItem(title: "Payments", image: payment, tag: 0)
        rootVC.pushViewController(paymentVC, animated: false)
    }

    @objc private func makePaymentTapped(_ sender: Any?) {

    }
}
