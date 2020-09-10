//
//  ESBBordered.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/9/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

protocol ESBBordered {
    var lightModeBorderColor: UIColor { get }
    var darkModeBorderColor: UIColor { get }
    var borderWidth: CGFloat { get }
    var cornerRadius: CGFloat { get }
}

extension ESBBordered where Self: UIView {
    var lightModeBorderColor: UIColor {
        UIColor.downyBlue.adjustingBrightness(by: -0.3).withAlphaComponent(0.8)
    }
    var darkModeBorderColor: UIColor {
        UIColor.downyBlue.withAlphaComponent(0.8)
    }
    var borderWidth: CGFloat { 0.5 }
    var cornerRadius: CGFloat { 5.0 }
    
    func updateBorderColor() {
        switch traitCollection.userInterfaceStyle {
        case .light:
            layer.borderColor = lightModeBorderColor.cgColor
        case .dark:
            layer.borderColor = darkModeBorderColor.cgColor
        default:
            break
        }
    }
    
    func configureBorder() {
        backgroundColor = .systemBackground
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        updateBorderColor()
    }
}
