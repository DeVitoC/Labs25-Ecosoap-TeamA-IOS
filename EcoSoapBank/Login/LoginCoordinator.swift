//
//  LoginCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-18.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth


protocol LoginCoordinatorDelegate: AnyObject {
    var loginURL: URL? { get }
    
    func loginDidComplete()
}


class LoginCoordinator: FlowCoordinator {
    private var rootVC: UIViewController
    private lazy var loginVC = UIStoryboard.main.instantiateViewController(
        identifier: LoginViewController.storyboardID) { coder in
            LoginViewController(coder: coder, delegate: self)
    }

    private weak var delegate: LoginCoordinatorDelegate?

    private var observers: [NSObjectProtocol] = []

    // MARK: - Init/Start

    init(root: UIViewController, delegate: LoginCoordinatorDelegate) {
        self.rootVC = root
        self.delegate = delegate

        loginVC.modalPresentationStyle = .fullScreen
        
        let authSuccessObserver = NotificationCenter.default.addObserver(
            forName: .oktaAuthenticationSuccessful,
            object: nil,
            queue: .main,
            using: loginDidComplete)
        let authExpiredObserver = NotificationCenter.default.addObserver(
            forName: .oktaAuthenticationExpired,
            object: nil,
            queue: .main,
            using: alertUserOfExpiredCredentials)
        observers.append(contentsOf: [authSuccessObserver, authExpiredObserver])
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

    private func alertUserOfExpiredCredentials(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak rootVC] in
            rootVC?.presentSimpleAlert(
                with: "Your Okta credentials have expired",
                message: "Please sign in again",
                preferredStyle: .alert,
                dismissText: "OK") { [weak self] _ in
                    self?.showLoginScreen()
            }

        }
    }

    private func loginDidComplete(_ notification: Notification) {
        delegate?.loginDidComplete()
    }
}

// MARK: - LoginVC Delegate

extension LoginCoordinator: LoginViewControllerDelegate {
    func login() {
        guard let loginURL = delegate?.loginURL else {
            NSLog("Cannot get login URL for Okta Auth")
            return // TODO: handle faulty login URL?
        }
        UIApplication.shared.open(loginURL)
    }
}
