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


/// Handles interoperation between different app modules, overall app UI flow.
class AppFlowCoordinator: FlowCoordinator {
    /// The main app window.
    let window: UIWindow

    /// The main app tab bar controller.
    private lazy var tabBarController = AppTabBarController()

    // Coordinators for each app 'module'

    private var impactCoord: ImpactCoordinator?
    private var pickupCoord: PickupCoordinator?
    private var paymentCoord: PaymentCoordinator?
    private var profileCoord: ProfileCoordinator?
    private lazy var loginCoord = LoginCoordinator(root: tabBarController)

    /// Handles business logic related to user, login, profile, and properties.
    private(set) lazy var userController = UserController(dataLoader: userProvider)

    // MARK: - Data Providers

    private var graphQLController = GraphQLController()

    // Data providers for app modules.

    private lazy var userProvider: UserDataProvider = useMock ? MockUserDataProvider() : graphQLController
    private lazy var pickupProvider: PickupDataProvider = useMock ? MockPickupProvider() : graphQLController
    private lazy var impactProvider: ImpactDataProvider = useMock ? MockImpactProvider() : graphQLController
    private lazy var paymentProvider: PaymentDataProvider = useMock ? MockPaymentProvider() : graphQLController

    // MARK: - Init / Start

    /// Holds subscription to changes in user, allowing app coordinator to respond to log-in, log-out, and other events that may cause the user to change.
    private var userSubscription: AnyCancellable?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        userSubscription = subscribeToUserChanges()

        // set up window and make visible
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        // if bearer from Okta is present, user bearer to fetch User from GraphQL; otherwise, log in with Okta to get bearer
        if Keychain.Okta.isLoggedIn || skipLogin {
            tabBarController.present(
                LoadingViewController(loadingText: "Logging in..."),
                animated: false,
                completion: nil)
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

    /// Called after attempting to fetch the User from backend. If successful, starts all module coordinators and sets up tab bar controller.
    private func onLoginComplete(withUser user: User?) {
        guard let user = user else {
            guard userController.user != nil else {
                return self.presentLoginFailAlert(error: LoginError.loginFailed)
            }
            return loginCoord.start()
        }

        // when backend ready, use graphQL controller as data provider
        self.pickupCoord = PickupCoordinator(user: user, dataProvider: self.pickupProvider)
        self.impactCoord = ImpactCoordinator(user: user, dataProvider: self.impactProvider)
        self.paymentCoord = PaymentCoordinator(user: user, dataProvider: self.paymentProvider)
        self.profileCoord = ProfileCoordinator(
            user: user,
            userController: self.userController,
            delegate: self)

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

        tabBarController.dismissAllPresentedViewControllers(onComplete: nil)
        userSubscription = nil
    }

    private func subscribeToUserChanges() -> AnyCancellable {
        userController.$user
            .dropFirst(1)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newUser in
                self?.onLoginComplete(withUser: newUser)
            })
    }
}

// MARK: - Profile Delegate

extension AppFlowCoordinator: ProfileDelegate {
    func logOut() {
        userSubscription = subscribeToUserChanges()
        loginCoord.start()
    }
}
