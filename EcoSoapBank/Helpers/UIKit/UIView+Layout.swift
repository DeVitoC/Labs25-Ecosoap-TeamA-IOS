//
//  UIView+Layout.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIView {
    
    func fillSuperview(withPadding padding: UIEdgeInsets = .zero) {
        assert(translatesAutoresizingMaskIntoConstraints == false,
               "translatesAutoresizingMaskIntoConstraints must be set to false for view to use autolayout")
        
        guard let superview = superview else {
            assertionFailure("\(Self.self) has no superview to fill")
            return
        }
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: padding.right),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: padding.bottom),
        ])
    }
}
