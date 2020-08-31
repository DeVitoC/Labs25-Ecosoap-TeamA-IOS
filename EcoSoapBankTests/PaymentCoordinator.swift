//
//  PaymentCoordinator.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/27/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PaymentCoordinator: FlowCoordinator {

    init(user: User, dataProvider: ImpactDataProvider) {
        rootVC = configure(PaymentViewController()) {
            $0.paymentController = PaymentController(user: user, dataProvider: dataProvider)
        }
    }

    let rootVC: PaymentViewController

    func start() {
        let globe = UIImage(
            systemName: "dolarsign.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        )
        rootVC.tabBarItem = UITabBarItem(title: "Payments", image: globe, tag: 0)
    }
}
