//
//  ESBButton.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/19/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ESBButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        let borderView = configure(GradientView()) {
            $0.startPoint = CGPoint(x: 0, y: 0)
            $0.endPoint = CGPoint(x: 1, y: 0)
            $0.colors = [.esbGreen, .downyBlue]
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 2.0
            $0.layer.cornerRadius = 8.0
            $0.isUserInteractionEnabled = false
        }
        
        addSubview(borderView)
        borderView.fillSuperview()
        
        let backgroundView = configure(UIView()) {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 6.0
            $0.isUserInteractionEnabled = false
        }

        addSubview(backgroundView)
        backgroundView.constrain(with: backgroundView.constraints(for: self, to: .all, constant: 6))
        
        setTitleColor(.esbGreen, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = 44
        return size
    }
}
