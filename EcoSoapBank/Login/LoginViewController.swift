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
        
        let logo = ESBCircularImageView(image: UIImage(named: "esbLogo")!)
        
        let button = ESBButton()
        button.setTitle("SIGN IN WITH OKTA", for: .normal)
        button.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
        
        view.addSubviewsUsingAutolayout(button)
        
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

class ESBCircularImageView: UIView {
    let imageView: UIImageView
    
    init(image: UIImage) {
        self.imageView = UIImageView(image: image)
        super.init(frame: .zero)
        
        setUp()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func setUp() {
        addSubview(imageView)
        imageView.constrain(with: imageView.constraints(from: self, toSides: .all, constant: 6))
    }
}
