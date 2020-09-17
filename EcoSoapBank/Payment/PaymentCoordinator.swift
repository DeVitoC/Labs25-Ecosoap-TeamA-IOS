//
//  PaymentCoordinator.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/27/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

/// Coordinator that initializes and starts the ImpactViewController
class PaymentCoordinator: FlowCoordinator {

    /// Initializer that takes in a **User** and **PaymentDataProvider** and initializes the **PaymentCoordinator**
    /// - Parameters:
    ///   - user: A **User** object that will provide the information for the **PaymentViewController**
    ///   - dataProvider: Takes an object that conforms to the protocol **PaymentDataProvider**. Allows for either live or mock data.
    init(user: User, dataProvider: PaymentDataProvider) {
        paymentVC.paymentController = PaymentController(user: user,
                                                        dataProvider: dataProvider)
    }

    // rootVC is the base controller that will be opened.
    // In this case, the UINavigationController that will provide the navigation bar and stack
    let rootVC = UINavigationController()
    // paymentVC is the PaymentViewController that will be started via the rootVC
    let paymentVC = PaymentHistoryViewController()

    /// Starts the rootVC and pushes the paymentVC to be the current VC. Initialized with a "dollarsign.circle" image for the tab
    func start() {
        let payment = UIImage(
            systemName: "dollarsign.circle",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        )
        rootVC.tabBarItem = UITabBarItem(title: "Payments", image: payment, tag: 0)
        rootVC.pushViewController(paymentVC, animated: false)
    }
}
