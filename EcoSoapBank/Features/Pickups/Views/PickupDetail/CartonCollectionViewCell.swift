//
//  CartonCollectionViewCell.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/15/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class CartonCollectionViewCell: UICollectionViewCell {

    var carton: Pickup.Carton? { didSet { updateViews() } }
    
    @IBOutlet private var productLabel: UILabel! {
        didSet {
            productLabel.font = .preferredMuli(forTextStyle: .subheadline)
            productLabel.textColor = UIColor.label
        }
    }
    @IBOutlet private var cartonView: CartonView!
    @IBOutlet private var percentFullLabel: UILabel! {
        didSet {
            percentFullLabel.font = .preferredMuli(forTextStyle: .caption1, typeface: .semiBold)
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
