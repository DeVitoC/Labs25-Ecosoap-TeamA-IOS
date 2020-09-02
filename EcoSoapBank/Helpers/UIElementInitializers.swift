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
    func createLabel(_ title: String, frame: CGRect, alignment: NSTextAlignment, textColor: UIColor = .white) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textAlignment = alignment
        label.textColor = textColor

        return label
    }

    /**
     Create a UIStackView with title, frame, alignment and textColor passed in.

     - Parameter axis: **NSLayoutConstraint.Axis** that describes the UIStackView's axis property
     - Parameter alignment: **UIStackView.Alignment** that describes the UIStackView's alignment property
     - Parameter distribution: **UIStackView.Distribution** that describes the UIStackView's distribution property
     - Parameter spacing: **CGFloat** that describes the UIStackView's spacing property
     - Returns: A **UIStackView** set up to the the passed in specifications.
     */
    func createElementStackView(axis: NSLayoutConstraint.Axis = .horizontal,
                                alignment: UIStackView.Alignment = .center,
                                distribution: UIStackView.Distribution = .fillEqually,
                                spacing: CGFloat = 5) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing

        return stackView
    }

}
