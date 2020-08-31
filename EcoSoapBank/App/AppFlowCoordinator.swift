//
//  AppFlowCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-05.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import KeychainAccess
import UIKit
import OktaAuth


class AppFlowCoordinator: FlowCoordinator {
    let window: UIWindow

    private(set) lazy var tabBarController = UITabBarController()

    private(set) var impactCoord: ImpactCoordinator?
    private(set) var pickupCoord: PickupCoordinator?
    private(set) lazy var loginCoord = LoginCoordinator(
        root: tabBarController,
        userController: userController,
        onLoginComplete: { [weak self] in self?.onLoginComplete() })
    private(set) lazy var userController = UserController(dataLoader: userProvider)

    // MARK: - Data Providers

    private var graphQLController = GraphQLController()

    private lazy var userProvider: UserDataProvider = useMock ? MockLoginProvider() : graphQLController
    private lazy var pickupProvider: PickupDataProvider = useMock ? MockPickupProvider() : graphQLController
    private lazy var impactProvider: ImpactDataProvider = useMock ? MockImpactProvider() : graphQLController

    // MARK: - Init / Start

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

        // set up window and make visible
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        if Keychain.Okta.isLoggedIn {
            tabBarController.present(LoadingViewController(loadingText: "Logging in..."), animated: false, completion: nil)
            userController.logInWithBearer { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        self?.presentLoginFailAlert(error: error)
                    case .success:
                        self?.onLoginComplete()
                    }
                }
            }
        } else {
            loginCoord.start()
        }
    }

    // MARK: - Methods

    func presentLoginFailAlert(error: Error? = nil) {
        if tabBarController.presentedViewController != nil {
            tabBarController.dismiss(animated: true) { [weak self] in
                self?.presentLoginFailAlert(error: error)
            }
        }
        tabBarController.presentAlert(for: error)
    }

    private func onLoginComplete() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                var topLevelVC = UIApplication.shared.windows
                    .first(where: { !$0.isHidden && $0.isKeyWindow })?
                    .rootViewController
                if let presentedVC = topLevelVC?.presentedViewController {
                    topLevelVC = presentedVC
                }
                topLevelVC?.presentSimpleAlert(
                    with: "Sorry! An unknown error occurred!",
                    message: "Please contact the app developers with information about how you got here. Thanks!",
                    preferredStyle: .alert,
                    dismissText: "OK")
                return assertionFailure("AppFlowCoordinator unexpectedly deinitialized before login completion")
            }
            guard let user = self.userController.user else {
                return self.presentLoginFailAlert()
            }

            // when backend ready, use graphQL controller as data provider
            self.pickupCoord = PickupCoordinator(user: user, dataProvider: self.pickupProvider)
            self.impactCoord = ImpactCoordinator(user: user, dataProvider: self.impactProvider)

            self.tabBarController.setViewControllers([
                self.impactCoord!.rootVC,
                self.pickupCoord!.rootVC
            ], animated: false)

            self.impactCoord!.start()
            self.pickupCoord!.start()

            if self.tabBarController.presentedViewController != nil {
                self.tabBarController.dismiss(animated: true, completion: nil)
            }
        }
    }
}


// MARK: - Use Mock

let useMock: Bool = true
