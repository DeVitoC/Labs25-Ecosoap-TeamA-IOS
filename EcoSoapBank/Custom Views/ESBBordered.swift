//
//  ESBBordered.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/9/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

protocol ESBBordered {
    func updateBorderColor()
    func configureBorder()
}

extension ESBBordered where Self: UIView {
    func updateBorderColor() {
        switch traitCollection.userInterfaceStyle {
        case .light:
            layer.borderColor = UIColor.downyBlue.adjustingBrightness(by: -0.3).withAlphaComponent(0.8).cgColor
        case .dark:
            layer.borderColor = UIColor.downyBlue.withAlphaComponent(0.8).cgColor
        default:
            break
        }
    }
    
    func configureBorder() {
        backgroundColor = .systemBackground
        clipsToBounds = true
        layer.cornerRadius = 5.0
        layer.borderWidth = 0.5
        updateBorderColor()
    }
}
