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

    private(set) lazy var tabBarController = AppTabBarController()

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

    private lazy var userProvider: UserDataProvider = useMock ? MockUserDataProvider() : graphQLController
    private lazy var pickupProvider: PickupDataProvider = useMock ? MockPickupProvider() : graphQLController
    private lazy var impactProvider: ImpactDataProvider = useMock ? MockImpactProvider() : graphQLController
    private lazy var paymentProvider: PaymentDataProvider = useMock ? MockPaymentProvider() : graphQLController

    // MARK: - Init / Start

    private var userSubscription: AnyCancellable?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        userSubscription = makeUserChangesSubscription()

        // set up window and make visible
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        let shouldSkipLogin: Bool = {
            if case .useMock(let skipLogin) = mockStatus {
                return skipLogin
            } else {
                return false
            }
        }()

        if Keychain.Okta.isLoggedIn || shouldSkipLogin {
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

    private func makeUserChangesSubscription() -> AnyCancellable {
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
        userSubscription = makeUserChangesSubscription()
        loginCoord.start()
    }
}


// MARK: - Use Mock

let mockStatus: MockStatus = .useMock(skipLogin: true)

var useMock: Bool {
    if case .useMock = mockStatus {
        return true
    } else {
        return false
    }
}

enum MockStatus {
    case live
    case useMock(skipLogin: Bool)
}
