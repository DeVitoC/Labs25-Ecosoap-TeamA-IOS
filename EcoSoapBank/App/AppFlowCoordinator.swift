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
import Combine


class AppFlowCoordinator: FlowCoordinator {
    let window: UIWindow

    private(set) lazy var tabBarController = UITabBarController()

    private(set) var impactCoord: ImpactCoordinator?
    private(set) var pickupCoord: PickupCoordinator?
    private(set) var paymentCoord: PaymentCoordinator?
    private(set) var profileCoord: ProfileCoordinator?
    private(set) lazy var loginCoord = LoginCoordinator(
        root: tabBarController,
        userController: userController)
    private(set) lazy var userController = UserController(dataLoader: userProvider)

    // MARK: - Data Providers

    private var graphQLController = GraphQLController()

    private lazy var userProvider: UserDataProvider = useMock ? MockLoginProvider() : graphQLController
    private lazy var pickupProvider: PickupDataProvider = useMock ? MockPickupProvider() : graphQLController
    private lazy var impactProvider: ImpactDataProvider = useMock ? MockImpactProvider() : graphQLController
    private lazy var paymentProvider: PaymentDataProvider = useMock ? MockPaymentProvider() : graphQLController

    // MARK: - Init / Start

    private var cancellables = Set<AnyCancellable>()

    init(window: UIWindow) {
        self.window = window

        userController.$user
            .dropFirst(1)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.onLoginComplete(withUser: $0) }
            .store(in: &cancellables)
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
                    case .success(let user):
                        self?.onLoginComplete(withUser: user)
                    }
                }
            }
        } else {
            loginCoord.start()
        }
    }

    // MARK: - Methods

    func presentLoginFailAlert(error: Error? = nil) {
        tabBarController.presentAlert(for: error, actions: [
            .okay({ _ in
                if self.tabBarController.presentedViewController != nil {
                    self.tabBarController.dismiss(animated: true) {
                        self.loginCoord.start()
                    }
                } else {
                    self.loginCoord.start()
                }
            })
        ])
    }

    private func onLoginComplete(withUser user: User?) {
        guard let user = user else {
            return self.presentLoginFailAlert(error: LoginError.loginFailed)
        }

        // when backend ready, use graphQL controller as data provider
        self.pickupCoord = PickupCoordinator(user: user, dataProvider: self.pickupProvider)
        self.impactCoord = ImpactCoordinator(user: user, dataProvider: self.impactProvider)
        self.paymentCoord = PaymentCoordinator(user: user, dataProvider: self.paymentProvider)
        self.profileCoord = ProfileCoordinator(userController: self.userController)

        self.tabBarController.setViewControllers([
            self.impactCoord!.rootVC,
            self.pickupCoord!.rootVC,
            self.paymentCoord!.rootVC,
            self.profileCoord!.rootVC
        ], animated: false)

        self.impactCoord!.start()
        self.pickupCoord!.start()
        self.paymentCoord!.start()
        self.profileCoord!.start()

        if self.tabBarController.presentedViewController != nil {
            self.tabBarController.dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: - Use Mock

let useMock: Bool = false
