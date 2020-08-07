//
//  AppFlowCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-05.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class AppFlowCoordinator: FlowCoordinator {
    let window: UIWindow

    let tabBarController = UITabBarController()

    let impactCoord = ImpactCoordinator()
    let pickupCoord = PickupCoordinator()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        tabBarController.viewControllers = [
            impactCoord.rootVC,
            pickupCoord.rootVC
        ]

        impactCoord.start()
        pickupCoord.start()

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

