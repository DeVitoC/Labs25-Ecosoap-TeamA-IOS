//
//  UIElementInitializers.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 9/1/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class UIElementInitializers: NSObject {

    /**
     Create a UILabel with title, frame,alignment, and textColor passed in.

     - Parameter title: **String** that describes the UILabel's text property
     - Parameter frame: **CGRect** that describes the initial dimensions of the UILabel
     - Parameter alignment: **NSTextAlignment** that describes the UILabel's  textAlignment property
     - Parameter textColor: **UIColor** that describes the UILabel's textColor property
     - Returns: A **UILabel** set up to the specifications passed in.
     */
    func createLabel(_ title: String, frame: CGRect, alignment: NSTextAlignment, textColor: UIColor = .label) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textAlignment = alignment
        label.textColor = textColor

        return label
    }

    func createImageView(_ imageNamed: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: imageNamed, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray

        return imageView
    }
}
