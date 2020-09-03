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
        case greenOnPrimary
        case primaryOnGradient
    }
    
    // MARK: - Public Properties
    
    var colorScheme: ColorScheme = .primaryOnGradient {
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
        case .greenOnPrimary:
            setTitleColor(UIColor.esbGreen.orInverse(defaultLight: false), for: .normal)
            backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
            backgroundGradient?.removeFromSuperview()
            backgroundGradient = nil
        case .primaryOnGradient:
            setTitleColor(UIColor.label, for: .normal)
            backgroundGradient = configure(GradientView()) {
                $0.colors = [UIColor.esbGreen.orInverse(),
                             UIColor.downyBlue.orInverse()]
                $0.startPoint = CGPoint(x: 0, y: 0)
                $0.endPoint = CGPoint(x: 1, y: 0)
            }
            addSubview(backgroundGradient!)
            backgroundGradient?.fillSuperview()
        }
    }
    
    private func setUp() {
        updateColors()
        clipsToBounds = true
        layer.cornerRadius = 8.0
        titleLabel?.font = .muli( style: .body, typeface: .semiBold)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
