//
//  LoginViewController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import OktaAuth
import SwiftUI
import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func login()
}

class LoginViewController: UIViewController {
    weak var delegate: LoginViewControllerDelegate?
    
    // MARK: - Init
    
    init(delegate: LoginViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = BackgroundView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }
    
    // MARK: - Private Methods
    
    func setUpSubviews() {
        let logo = ESBCircularImageView(image: UIImage(named: "esbLogoWhite")!)
        view.addSubview(logo)
        
        logo.centerHorizontallyInSuperview()
        logo.centerVerticallyInSuperview(multiplier: 0.7)
        logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45).isActive = true
        
        let missionStatementLabel = configure(UILabel()) {
            $0.text =
            """
            Saving, sanitizing, and supplying
            RECYCLED SOAP
            for the developing world
            """
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = .white
            $0.font = .montserrat(style: .body, typeface: .semiBold)
        }
        view.addSubview(missionStatementLabel)
        
        missionStatementLabel.centerHorizontallyInSuperview()
        missionStatementLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 40).isActive = true
        
        let signInButton = configure(ESBButton()) {
            $0.colorScheme = .greenOnWhite
            $0.setTitle("SIGN IN WITH OKTA", for: .normal)
            $0.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
        }
        
        view.addSubview(signInButton)
        
        signInButton.centerVerticallyInSuperview(multiplier: 1.7)
        signInButton.constrain(with: signInButton.constraints(from: view,
                                                              toSides: [LayoutSide.leading, LayoutSide.trailing],
                                                              constant: 40))
    }
    
    // MARK: - Actions
    
    @objc func signIn(_ sender: UIButton) {
        delegate?.login()
    }
}

struct LoginVCWrapper: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<LoginVCWrapper>) -> UIView {
        LoginViewController(delegate: nil).view
    }
    
    func updateUIView(_ uiView: LoginVCWrapper.UIViewType, context: UIViewRepresentableContext<LoginVCWrapper>) {
    }
}

struct LoginVCWrapper_Previews: PreviewProvider {
    static var previews: some View {
        LoginVCWrapper().edgesIgnoringSafeArea(.all)
    }
}
