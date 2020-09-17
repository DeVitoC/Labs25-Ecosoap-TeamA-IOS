//
//  ImpactCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

/// Coordinator that initializes and starts the ImpactViewController
class ImpactCoordinator: FlowCoordinator {

    /// Initializer that takes in a **User** and **ImpactDataProvider** and initializes the **ImpactCoordinator**
    /// - Parameters:
    ///   - user: A **User** object that will provide the information for the **ImpactViewController**
    ///   - dataProvider: Takes an object that conforms to the protocol **ImpactDataProvider**. Allows for either live or mock data.
    init(user: User, dataProvider: ImpactDataProvider) {
        impactVC.impactController = ImpactController(user: user, dataProvider: dataProvider)
    }

    // rootVC is the base controller that will be opened.
    // In this case, the UINavigationController that will provide the navigation bar and stack
    let rootVC = UINavigationController()
    // impactVC is the ImpactViewController that will be started via the rootVC
    let impactVC = ImpactViewController()

    /// Starts the rootVC and pushes the impactVC to be the current VC. Initialized with a "globe" image for the tab
    func start() {
        let globe = UIImage(
            systemName: "globe",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        )
        rootVC.tabBarItem = UITabBarItem(title: "Impact", image: globe, tag: 0)
        rootVC.pushViewController(impactVC, animated: false)
    }
}
