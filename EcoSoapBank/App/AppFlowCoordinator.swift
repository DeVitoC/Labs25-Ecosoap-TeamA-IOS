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

    private(set) lazy var tabBarController = UITabBarController()

    private(set) lazy var impactCoord = ImpactCoordinator()
    private(set) lazy var pickupCoord = PickupCoordinator()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        // set default tabBar/navBar appearance
        UITabBar.appearance().tintColor = .esbGreen
        configure(UINavigationBar.appearance(), with: {
            $0.titleTextAttributes = [.font: UIFont.Montserrat.navBarInlineTitle]
            $0.largeTitleTextAttributes = [
                .font: UIFont.Montserrat.navBarLargeTitle,
                .foregroundColor: UIColor.white
            ]
            $0.backgroundColor = .esbGreen
            // We can use `$0.barTintColor = .esbGreen` if we want the `inline` version of the title bar to be that color
        })

        // set up tabBarController, start other coordinators
        tabBarController.viewControllers = [
            impactCoord.rootVC,
            pickupCoord.rootVC
        ]
        impactCoord.start()
        pickupCoord.start()

        // set up window and make visible
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
