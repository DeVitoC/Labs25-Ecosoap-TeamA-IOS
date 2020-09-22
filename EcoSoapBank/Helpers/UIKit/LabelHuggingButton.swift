//
//  LabelHuggingButton.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-21.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


/// A button that hugs its title label more than a regular UIButton, helping to align with labels.
class LabelHuggingButton: UIButton {
    override var intrinsicContentSize: CGSize {
        titleLabel?.intrinsicContentSize ?? .zero
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = titleLabel?.frame.size.width ?? .zero
    }
}
