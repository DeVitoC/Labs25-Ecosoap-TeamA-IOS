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
        
        let logo = ESBCircularImageView(image: UIImage(named: "esbLogoWhite")!)
        view.addSubview(logo)
        
        logo.centerHorizontallyInSuperview()
        logo.centerVerticallyInSuperview(multiplier: 0.5)
        logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        
        let button = configure(ESBButton()) {
            $0.setTitle("SIGN IN WITH OKTA", for: .normal)
            $0.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
        }
        
        view.addSubview(button)
        
        button.centerVerticallyInSuperview(multiplier: 1.7)
        button.constrain(with: button.constraints(from: view,
                                                  toSides: [LayoutSide.leading, LayoutSide.trailing],
                                                  constant: 40))
    }
    
    init(delegate: LoginViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func signIn(_ sender: UIButton) {
        delegate?.login()
    }
}
