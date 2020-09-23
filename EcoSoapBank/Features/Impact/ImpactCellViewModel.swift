//
//  ImpactCellViewModel.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

struct ImpactCellViewModel {
    enum Unit {
        case grams
        case people
    }
    
    var title: String {
        switch unit {
        case .grams:
            return Measurement(value: Double(amount), unit: UnitMass.grams).string
        case .people:
            return String(amount)
        }
    }
    
    let amount: Int
    let unit: Unit
    let subtitle: String
    let image: UIImage
}
