//
//  UIElementInitializers.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 9/1/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(
        _ title: String,
        frame: CGRect = .zero,
        alignment: NSTextAlignment = .left,
        textColor: UIColor = .label
    ) {
        self.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = title
        self.textAlignment = alignment
        self.textColor = textColor
    }
}

extension UIImageView {
    convenience init(systemName: String) {
        self.init(image: UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = .lightGray
    }
}

extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis = .vertical,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 8
    ) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}
