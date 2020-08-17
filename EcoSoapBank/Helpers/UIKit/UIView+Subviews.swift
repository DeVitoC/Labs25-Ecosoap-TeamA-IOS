//
//  UIView+Subviews.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewsUsingAutolayout(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    func removeSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
