//
//  ESBButton.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/19/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ESBButton: UIButton {
    enum ColorScheme {
        case greenOnWhite
        case whiteOnGreen
    }
    
    // MARK: - Public Properties
    
    var colorScheme: ColorScheme = .whiteOnGreen {
        didSet { updateColors() }
    }
    
    // MARK: - Private Properties
    
    private var backgroundGradient: GradientView?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: - Overrides
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = 46
        return size
    }
    
    // MARK: - Private Methods
    
    private func updateColors() {
        switch colorScheme {
        case .greenOnWhite:
            setTitleColor(
                .esbGreen,
                for: .normal)
            backgroundColor = .white
        case .whiteOnGreen:
            setTitleColor(UIColor.white, for: .normal)
            backgroundColor = .esbGreen
        }
    }
    
    private func setUp() {
        updateColors()
        clipsToBounds = true
        layer.cornerRadius = 8.0
        titleLabel?.font = .muli( style: .title3, typeface: .semiBold)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
