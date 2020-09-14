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
     - Parameter textColor: **UIColor** that describes the UILabel's textColor property (defaults to `.label`)

     Sets `translatesAutoresizingMaskIntoConstraints` to `false`.
     */
    convenience init(_ title: String, frame: CGRect, alignment: NSTextAlignment, textColor: UIColor = .label) {
        self.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = title
        self.textAlignment = alignment
        self.textColor = textColor
    }
}

extension UIImageView {
    /// Initializes a UIImageView with image name, configuration
    /// - Parameter systemName: **String** with the system name for the image
    /// - Parameter configuration: Defaults to `.init(pointSize: 16, weight: .semibold)`
    /// - Parameter tintColor: Defaults to `.tertiaryLabel`
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints` to `false`.
    convenience init(
        _ systemName: String,
        configuration: UIImage.SymbolConfiguration = .init(pointSize: 16, weight: .semibold),
        tintColor: UIColor = .tertiaryLabel
    ) {
        self.init(image: UIImage(systemName: systemName, withConfiguration: configuration))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = tintColor
    }
}

extension UIStackView {
    /// Initializes a stack view with the given parameters and arranged subviews.
    ///
    /// - Parameters:
    ///   - axis: Default `.vertical`
    ///   - alignment: Default `.fill`
    ///   - distribution: Default `.fill`
    ///   - spacing: Default `8`
    ///   - arrangedSubviews: Default `[]`
    convenience init(
        axis: NSLayoutConstraint.Axis = .vertical,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 8,
        arrangedSubviews: [UIView] = []
    ) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        arrangedSubviews.forEach(addArrangedSubview(_:))
    }
}
