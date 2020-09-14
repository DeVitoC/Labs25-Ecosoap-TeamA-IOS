//
//  PickupDetailCartonCell.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PickupDetailCartonCell: UICollectionViewCell {
    var carton: Pickup.Carton? { didSet { updateViews() } }
    
    @IBOutlet private var productLabel: UILabel! {
        didSet {
            productLabel.font = UIFont.muliScaled(style: .callout, typeface: .regular)
            productLabel.textColor = UIColor.label
        }
    }
    @IBOutlet private var cartonView: CartonView!
    @IBOutlet private var percentFullLabel: UILabel! {
        didSet {
            percentFullLabel.font = UIFont.muliScaled(style: .caption1, typeface: .semiBold)
            percentFullLabel.textColor = UIColor.codGrey.orInverse()
        }
    }
    
    private func updateViews() {
        guard let cartonContents = carton?.contents else { return }
        
        productLabel.text = cartonContents.product.rawValue.capitalized
        cartonView.percentFull = cartonContents.percentFull
        percentFullLabel.text = ("\(cartonContents.percentFull)%")
    }
}
