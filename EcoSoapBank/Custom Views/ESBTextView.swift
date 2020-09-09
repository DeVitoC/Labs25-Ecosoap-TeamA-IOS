//
//  ESBTextView.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/8/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ESBTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            updateBorderColor()
        }
    }
    
    private func updateBorderColor() {
        switch traitCollection.userInterfaceStyle {
        case .light:
            layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        case .dark:
            layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        default:
            break
        }
    }
    
    private func setUp() {
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        updateBorderColor()
    }
}
