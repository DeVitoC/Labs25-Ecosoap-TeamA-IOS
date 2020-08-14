//
//  UIView+Subviews.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIView {
    // swiftlint:disable function_default_parameter_at_end
    func addSubviews(usingAutolayout: Bool = true, _ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = !usingAutolayout
            addSubview(view)
        }
    }
    
    func removeSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
