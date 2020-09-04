//
//  GradientView.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    // MARK: - Public Properties
    
    var colors: [UIColor] = [] { didSet { updateColors() } }
    var startPoint = CGPoint(x: 0, y: 0) { didSet { updateStartPoint() } }
    var endPoint = CGPoint(x: 0, y: 1) { didSet { updateEndPoint() } }
    
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
    
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            updateColors()
        }
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        isUserInteractionEnabled = false
        updateColors()
        updateStartPoint()
        updateEndPoint()
    }
    
    private func updateColors() {
        guard let layer = self.layer as? CAGradientLayer else { return }
        layer.colors = colors.map { $0.cgColor }
    }
    
    private func updateStartPoint() {
        guard let layer = self.layer as? CAGradientLayer else { return }
        layer.startPoint = startPoint
    }
    
    private func updateEndPoint() {
        guard let layer = self.layer as? CAGradientLayer else { return }
        layer.endPoint = endPoint
    }
}
