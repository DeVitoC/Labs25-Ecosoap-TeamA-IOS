//
//  ESBTextView.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/8/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ESBTextView: UITextView, ESBBordered {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
        configureBorder()
    }
}
