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
    func login()
}

class LoginViewController: UIViewController {
    weak var delegate: LoginViewControllerDelegate?
    
    override func loadView() {
        view = BackgroundView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    init(delegate: LoginViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func signIn(_ sender: Any) {
        delegate?.login()
    }
}
