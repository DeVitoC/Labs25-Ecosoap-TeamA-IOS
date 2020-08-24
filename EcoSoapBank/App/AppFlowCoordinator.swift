//
//  AppFlowCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-05.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth


class AppFlowCoordinator: FlowCoordinator {
    let window: UIWindow

    private(set) lazy var tabBarController = UITabBarController()

    private(set) lazy var impactCoord = ImpactCoordinator()
    private(set) var pickupCoord: PickupCoordinator?
    private(set) lazy var loginCoord = LoginCoordinator(
        root: tabBarController,
        userController: userController,
        onLoginComplete: { [weak self] in self?.onLoginComplete() })
    private(set) var userController = UserController(dataLoader: MockLoginProvider())

    private var appQuerier = AppQuerier()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        // set default tabBar/navBar appearance
        UITabBar.appearance().tintColor = .esbGreen
        UITabBar.appearance().backgroundColor = .downyBlue
        
        configure(UINavigationBar.appearance(), with: {
            $0.titleTextAttributes = [
                .font: UIFont.navBarInlineTitle,
                .foregroundColor: UIColor.white
            ]
            $0.largeTitleTextAttributes = [
                .font: UIFont.navBarLargeTitle,
                .foregroundColor: UIColor.white
            ]
            $0.backgroundColor = .esbGreen
            $0.setBackgroundImage(.navBar, for: .default)
            $0.tintColor = .white
            // We can use `$0.barTintColor = .esbGreen` if we want the `inline` version of the title bar to be that color
        })
        
        // set up tabBarController, start other coordinators
        tabBarController.viewControllers = [
            impactCoord.rootVC
        ]

        // set up window and make visible
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        if appQuerier.loggedIn {
            onLoginComplete()
        } else {
            loginCoord.start()
        }
    }

    func presentLoginFailAlert(error: Error? = nil) {
        let userError = error as? UserFacingError
        if tabBarController.presentedViewController != nil {
            tabBarController.dismiss(animated: true) { [weak self] in
                self?.presentLoginFailAlert(error: error)
            }
        }
        let message = userError?.userFacingDescription
            ?? "An unknown error occurred while logging in. Please try again."
        tabBarController.presentSimpleAlert(
            with: "Login failed",
            message: message,
            preferredStyle: .alert,
            dismissText: "OK"
        ) { [weak self] _ in
            self?.loginCoord.start()
        }
    }

    private func onLoginComplete() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // when backend ready: PickupCoordinator(dataProvider: appQuerier)
            self.pickupCoord = PickupCoordinator()
            self.tabBarController.setViewControllers([
                self.impactCoord.rootVC, self.pickupCoord!.rootVC
            ], animated: true)

            self.impactCoord.start()
            self.pickupCoord!.start()

            if self.tabBarController.presentedViewController != nil {
                self.tabBarController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
