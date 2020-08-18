//
//  LoginViewController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth

protocol LoginViewControllerDelegate: AnyObject {
    func loginDidFinish(_ success: Bool)
}

class LoginViewController: UIViewController {
    let profileController = ProfileController.shared

    weak var delegate: LoginViewControllerDelegate?

    var observers: [NSObjectProtocol] = []

    init?(coder: NSCoder, delegate: LoginViewControllerDelegate) {
        super.init(coder: coder)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let authSuccessObserver = NotificationCenter.default.addObserver(
            forName: .oktaAuthenticationSuccessful,
            object: nil,
            queue: .main,
            using: checkForExistingProfile)
        let authExpiredObserver = NotificationCenter.default.addObserver(
            forName: .oktaAuthenticationExpired,
            object: nil,
            queue: .main,
            using: alertUserOfExpiredCredentials)
        observers.append(contentsOf: [authSuccessObserver, authExpiredObserver])
    }

    deinit {
        observers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func signIn(_ sender: Any) {
        UIApplication.shared.open(ProfileController.shared.oktaAuth.identityAuthURL()!)
    }
    
    // MARK: - Private Methods
    
    private func alertUserOfExpiredCredentials(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presentSimpleAlert(
                with: "Your Okta credentials have expired",
                message: "Please sign in again",
                preferredStyle: .alert,
                dismissText: "Dimiss")
        }
    }
    
    // MARK: Notification Handling
    
    private func checkForExistingProfile(with notification: Notification) {
        checkForExistingProfile()
    }
    
    private func checkForExistingProfile() {
        profileController.checkForExistingAuthenticatedUserProfile { [weak delegate] exists in
            delegate?.loginDidFinish(exists)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalAddProfile" {
            guard let addProfileVC = segue.destination as? AddProfileViewController else { return }
            addProfileVC.delegate = self
        }
    }
}

// MARK: - Add Profile Delegate

extension LoginViewController: AddProfileDelegate {
    func profileWasAdded() {
        checkForExistingProfile()
    }
}
