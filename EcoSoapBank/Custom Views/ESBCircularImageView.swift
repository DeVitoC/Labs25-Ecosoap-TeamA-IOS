//
//  ESBCircularImageView.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/19/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ESBCircularImageView: GradientView {
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    var borderWidth: CGFloat = 2 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // MARK: - Private Properties
    
    private let imageView = configure(UIImageView()) {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Init
    
    init(image: UIImage? = nil, inset: CGFloat = 8.0, borderWidth: CGFloat = 2.0) {
        super.init(frame: .zero)
        self.image = image
        self.borderWidth = borderWidth
        setUp(withInset: inset)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            updateColors()
        }
    }
    
    // MARK: - Private methods
    
    func setUp(withInset inset: CGFloat) {
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 1, y: 0)
        updateColors()
        layer.borderWidth = borderWidth
        isUserInteractionEnabled = false

        addSubview(imageView)
        imageView.constrain(with: imageView.constraints(from: self, toSides: .all, constant: inset))

        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    func updateColors() {
        colors = [UIColor.esbGreen.orAdjustingBrightness(by: -0.25),
                  UIColor.downyBlue.orAdjustingBrightness(by: -0.25)]
        layer.borderColor = UIColor.systemBackground.cgColor
    }
}
