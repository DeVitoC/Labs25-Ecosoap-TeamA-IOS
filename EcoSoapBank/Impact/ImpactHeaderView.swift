//
//  ImpactHeaderView.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ImpactHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderView"
    
    var title: String? { didSet { updateViews() } }
    
    private var titleLabel = configure(UILabel()) {
        $0.font = UIFont.navBarLargeTitle
        $0.textColor = .label
    }
    
    private func updateViews() {
        titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        addSubviewsUsingAutolayout(titleLabel)
        titleLabel.constrain(with: [
            LayoutSide.leading.constraint(from: titleLabel, to: self, constant: 20),
            LayoutSide.top.constraint(from: titleLabel, to: self, constant: 40)
        ])
    }
}
