//
//  PropertySelectorCell.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

/// Sets up the view for each cell in the PropertySelector.
class PropertySelectorCell: UITableViewCell {
    
    let label = configure(UILabel()) {
        $0.textAlignment = .center
        $0.font = .montserrat(ofSize: 17, typeface: .medium)
        $0.textColor = .downyBlue
    }

    /// Initializes and configures the cell
    /// - Parameters:
    ///   - style: The **UITableViewCell.CellStyle** to use for the cell.
    ///   - reuseIdentifier: The reuseIdentifier for the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    /// Adds the label to the cell and configures it to display the specific property
    private func setUp() {
        addSubviewsUsingAutolayout(label)
        label.fillSuperview()
        
        backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
    }
}
