//
//  UINavigationController+Appearance.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-01.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.standardAppearance = configure(UINavigationBarAppearance()) {
            $0.backgroundImageContentMode = .scaleAspectFill
            $0.backgroundImage = UIImage.navBar.withAlpha(0.4)
            $0.backgroundColor = .systemBackground
            $0.backgroundEffect = UIBlurEffect(style: .systemMaterial)
            $0.titleTextAttributes = [
                .font: UIFont.navBarInlineTitle,
                .foregroundColor: UIColor.label
            ]
        }
        navigationBar.compactAppearance = configure(UINavigationBarAppearance()) {
            $0.backgroundImage = UIImage.navBar.withAlpha(0.4)
            $0.backgroundColor = .systemBackground
            $0.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
            $0.titleTextAttributes = [
                .font: UIFont.navBarInlineTitle,
                .foregroundColor: UIColor.label
            ]
        }
        navigationBar.scrollEdgeAppearance = configure(UINavigationBarAppearance()) {
            $0.configureWithTransparentBackground()
            $0.largeTitleTextAttributes = [
                .font: UIFont.navBarLargeTitle,
            ]
        }
    }
}
