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
    private(set) lazy var pickupCoord = PickupCoordinator()
    private(set) lazy var loginCoord = LoginCoordinator(
        root: tabBarController,
        delegate: self)

    let oktaAuth = OktaAuth(
        baseURL: URL(string: "https://auth.lambdalabs.dev/")!,
        clientID: "0oalwkxvqtKeHBmLI4x6",
        redirectURI: "labs://scaffolding/implicit/callback")

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
            impactCoord.rootVC,
            pickupCoord.rootVC
        ]

        // set up window and make visible
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        if appQuerier.loggedIn {
            impactCoord.start()
            pickupCoord.start()
        } else {
            loginCoord.start()
        }
    }

    func presentLoginFailAlert(error: UserFacingError? = nil) {
        if tabBarController.presentedViewController != nil {
            tabBarController.dismiss(animated: true) { [weak self] in
                self?.presentLoginFailAlert(error: error)
            }
        }
        let message = error?.userFacingDescription
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
}

extension AppFlowCoordinator: LoginCoordinatorDelegate {
    var loginURL: URL? { oktaAuth.identityAuthURL() }

    func oktaLoginDidComplete() {
        guard let token = try? oktaAuth.credentialsIfAvailable().accessToken else {
            preconditionFailure("Auth missing after successful login")
            // TODO: handle missing token after login
        }
        appQuerier.provideToken(token)
        appQuerier.logIn { [weak self] result in
            switch result {
            case .success:
                self?.impactCoord.start()
                self?.pickupCoord.start()
                self?.tabBarController.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self?.presentLoginFailAlert(error: error as? UserFacingError)
            }
        }
    }
}
