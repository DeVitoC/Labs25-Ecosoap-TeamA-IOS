//
//  PropertySelectionCell.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PropertySelectionCell: UITableViewCell {
    
    let label = configure(UILabel()) {
        $0.textAlignment = .center
        $0.font = .preferredMontserrat(forTextStyle: .caption2, typeface: .medium)
        $0.textColor = .downyBlue
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        addSubviewsUsingAutolayout(label)
        label.fillSuperview()
    }
}
