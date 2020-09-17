//
//  ESBTextField.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/9/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ESBTextField: UITextField, ESBBordered {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            updateBorderColor()
        }
    }
    
    private func setUp() {
        backgroundColor = .systemBackground
        borderStyle = .none
        configureBorder()
    }
}
