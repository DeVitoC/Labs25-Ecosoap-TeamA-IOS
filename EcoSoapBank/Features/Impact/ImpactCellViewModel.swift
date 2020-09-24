//
//  ImpactCellViewModel.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

/// Model describing the ImpactCell View Data including properties for a title,
/// amount, unit, subtitle, and image
struct ImpactCellViewModel {
    /// Enum that defines the two types of units that can be displayed in an ImpactCell
    /// grams for contributions made, and people for how many peoplehave been helped
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
