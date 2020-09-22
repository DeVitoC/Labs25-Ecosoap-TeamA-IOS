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


/// Coordinator that initializes and starts the LoginViewController
class LoginCoordinator: FlowCoordinator {

    // rootVC is the base controller that will be opened.
    // In this case, the UIViewController that is passed in the initializer
    private var rootVC: UIViewController
    private lazy var loginVC = LoginViewController(delegate: self)

    private var userController: UserController

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init/Start

    /// Initializer that takes in a **UIViewController** and **UserController** and initializes the **LoginCoordinator**
    /// - Parameters:
    ///   - root: The **UIViewController** to display
    ///   - userController: The **UserController** to manage the **User** being logged in
    init(
        root: UIViewController,
        userController: UserController
    ) {
        self.rootVC = root
        self.userController = userController
        
        loginVC.modalPresentationStyle = .fullScreen

        OktaAuth.error
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.rootVC.presentAlert(
                    for: $0,
                    actions: [.okay({ _ in self?.start() })]
                )
            }).store(in: &cancellables)
    }

    /// Calls the showLoginScreen method to start the rootVC which pushes the loginVC as the current ViewController.
    func start() {
        showLoginScreen()
    }
}

// MARK: - Private Helpers

extension LoginCoordinator {

    /// Calls the rootVC to push the loginVC as the current ViewController.
    private func showLoginScreen() {
        guard loginVC.presentedViewController == nil else {
            return loginVC.dismiss(animated: true, completion: showLoginScreen)
        }
        guard !loginVC.isBeingPresented, rootVC.presentedViewController == nil
            else { return }
        
        rootVC.present(loginVC, animated: true, completion: nil)
    }
}

// MARK: - LoginVC Delegate

extension LoginCoordinator: LoginViewControllerDelegate {
    /// Method that presents the LoadingViewController
    func login() {
        guard let loginURL = userController.oktaLoginURL else {
            return rootVC.presentAlert(for: LoginError.oktaFailure)
        }
        loginVC.present(LoadingViewController(loadingText: "Logging in..."), animated: true) {
            UIApplication.shared.open(loginURL)
        }
    }
}
