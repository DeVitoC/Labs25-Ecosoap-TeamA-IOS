//
//  LoginCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-18.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import Combine


enum LoginError: UserFacingError {
    case notLoggedIn
    case loginFailed
    case expiredCredentials
    case oktaFailure
    case other(Error)
    case unknown

    var userFacingDescription: String? {
        switch self {
        case .notLoggedIn:
            return "You're currently logged out."
        case .loginFailed:
            return "Login failed."
        case .expiredCredentials:
            return "Your Okta credentials have expired."
        case .oktaFailure:
            return "There's a problem with Okta's service."
        case .other(let otherError):
            return (otherError as? UserFacingError)?.userFacingDescription
        case .unknown:
            return nil
        }
    }
}


class LoginCoordinator: FlowCoordinator {
    private var rootVC: UIViewController
    private lazy var loginVC = LoginViewController(delegate: self)

    private var userController: UserController

    private var observers: [NSObjectProtocol] = []
    private var cancellables = Set<AnyCancellable>()

    private var onLoginComplete: () -> Void

    // MARK: - Init/Start

    init(
        root: UIViewController,
        userController: UserController,
        onLoginComplete: @escaping () -> Void
    ) {
        self.rootVC = root
        self.userController = userController
        self.onLoginComplete = onLoginComplete
        
        loginVC.modalPresentationStyle = .fullScreen

        NotificationCenter.default
            .publisher(for: .oktaAuthenticationExpired)
            .map { _ in LoginError.expiredCredentials }
            .sink(receiveValue: alertUserOfLoginError(_:))
            .store(in: &cancellables)
        userController.userPublisher
            .handleError(alertUserOfLoginError(_:))
            .compactMap { $0 }
            .map { _ in () }
            .sink(receiveValue: onLoginComplete)
            .store(in: &cancellables)
    }

    deinit {
        observers.forEach(NotificationCenter.default.removeObserver(_:))
    }

    func start() {
        showLoginScreen()
    }
}

// MARK: - Private Helpers

extension LoginCoordinator {
    private func showLoginScreen() {
        rootVC.present(loginVC, animated: true, completion: nil)
    }

    private func alertUserOfLoginError(_ error: Error) {
        let message = "Please log in."
        let title = (error as? UserFacingError)?.userFacingDescription
                        ?? "Login failed"
        (self.rootVC.presentedViewController ?? self.rootVC)?
            .presentSimpleAlert(
                with: title,
                message: message,
                preferredStyle: .alert,
                dismissText: "OK",
                completionUponDismissal: { [weak self] _ in self?.start() })
    }
}

// MARK: - LoginVC Delegate

extension LoginCoordinator: LoginViewControllerDelegate {
    func login() {
        guard let loginURL = userController.oktaLoginURL else {
            return alertUserOfLoginError(LoginError.oktaFailure)
        }
        UIApplication.shared.open(loginURL)
    }
}
