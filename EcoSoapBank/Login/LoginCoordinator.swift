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

    private var loginVC = UIStoryboard.main.instantiateViewController(
        identifier: LoginViewController.storyboardID) { coder in
            LoginViewController(coder: coder)
    }

    init(root: UIViewController) {
        self.rootVC = root
        rootVC.modalPresentationStyle = .fullScreen
    }

    func start() {
        rootVC.present(loginVC, animated: true, completion: nil)
    }
}
