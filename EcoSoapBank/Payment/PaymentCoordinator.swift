//
//  PaymentCoordinator.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/27/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PaymentCoordinator: FlowCoordinator {

    init(user: User, dataProvider: PaymentDataProvider) {
        rootVC = configure(PaymentHistoryViewController()) {
            $0.paymentController = PaymentController(user: user, dataProvider: dataProvider)
        }
    }

    let rootVC: PaymentHistoryViewController

    func start() {
        let payment = UIImage(
            systemName: "dollarsign.circle",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        )
        rootVC.tabBarItem = UITabBarItem(title: "Payments", image: payment, tag: 0)
    }
}
