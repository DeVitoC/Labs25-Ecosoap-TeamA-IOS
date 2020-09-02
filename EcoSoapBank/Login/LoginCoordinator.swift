//
//  LoginCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-18.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import Combine
import OktaAuth


enum LoginError: LocalizedError {
    case notLoggedIn
    case loginFailed
    case expiredCredentials
    case oktaFailure
    case other(Error)
    case unknown

    var errorDescription: String? {
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
            return (otherError as? LocalizedError)?.errorDescription
        case .unknown:
            return nil
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .notLoggedIn:
            return "Please log in to proceed."
        case .loginFailed:
            return "Please try again; did you enter the correct username/password?"
        case .expiredCredentials:
            return "Please log in again to renew your credentials."
        case .oktaFailure:
            return "Please try again later; sorry for the inconvenience."
        case .other(let otherError):
            return (otherError as? LocalizedError)?.recoverySuggestion
        case .unknown:
            return nil
        }
    }
}


class LoginCoordinator: FlowCoordinator {
    private var rootVC: UIViewController
    private lazy var loginVC = LoginViewController(delegate: self)

    private var userController: UserController

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init/Start

    init(
        root: UIViewController,
        userController: UserController
    ) {
        self.rootVC = root
        self.userController = userController
        
        loginVC.modalPresentationStyle = .fullScreen

        OktaAuth.error
            .sink { [weak self] in self?.alertUserOfLoginError($0) }
            .store(in: &cancellables)
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
        (self.rootVC.presentedViewController ?? self.rootVC)?.presentAlert(for: error)
    }
}

// MARK: - LoginVC Delegate

extension LoginCoordinator: LoginViewControllerDelegate {
    func login() {
        guard let loginURL = userController.oktaLoginURL else {
            return alertUserOfLoginError(LoginError.oktaFailure)
        }
        loginVC.present(LoadingViewController(loadingText: "Logging in..."), animated: true) {
            UIApplication.shared.open(loginURL)
        }
    }
}
