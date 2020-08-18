//
//  LoginCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-18.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class LoginCoordinator: FlowCoordinator {
    private var rootVC: UIViewController

    private lazy var loginVC = UIStoryboard.main.instantiateViewController(
        identifier: LoginViewController.storyboardID) { coder in
            LoginViewController(coder: coder, delegate: self)
    }

    init(root: UIViewController) {
        self.rootVC = root
        loginVC.modalPresentationStyle = .fullScreen
    }

    func start() {
        rootVC.present(loginVC, animated: true, completion: nil)
    }
}


extension LoginCoordinator: LoginViewControllerDelegate {
    func loginDidFinish(_ success: Bool) {
        if success {
            rootVC.dismiss(animated: true, completion: nil)
        } else {
            print("login failed!")
            // TODO: show alert that login failed
        }
    }
}
