//
//  UIElementInitializers.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 9/1/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UILabel {
    /**
     Initializes a UILabel with title, frame,alignment, and textColor passed in.
     - Parameter title: **String** that describes the UILabel's text property
     - Parameter frame: **CGRect** that describes the initial dimensions of the UILabel
     - Parameter alignment: **NSTextAlignment** that describes the UILabel's  textAlignment property
     - Parameter textColor: **UIColor** that describes the UILabel's textColor property
     */
    convenience init(_ title: String, frame: CGRect, alignment: NSTextAlignment, textColor: UIColor = .label) {
        self.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        text = title
        textAlignment = alignment
        self.textColor = textColor
    }
}

extension UIImageView {
    /// Initializes a UIImageView with image name
    /// - Parameter imageNamed: **String** with the system name for the image
    convenience init(_ imageNamed: String) {
        self.init(image: UIImage(systemName: imageNamed, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)))
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = .lightGray
    }
}
