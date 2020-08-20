//
//  ESBCircularImageView.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/19/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ESBCircularImageView: GradientView {
    let imageView = configure(UIImageView()) {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    init(image: UIImage) {
        self.imageView.image = image
        super.init(frame: .zero)
        
        setUp()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }
    
    func setUp() {
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 0)
        colors = [.esbGreen, .downyBlue]
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
        isUserInteractionEnabled = false
        
        addSubview(imageView)
        imageView.constrain(with: imageView.constraints(from: self, toSides: .all, constant: 10))
    
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
