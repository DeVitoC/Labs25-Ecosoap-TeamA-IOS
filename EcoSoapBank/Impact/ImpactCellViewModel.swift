//
//  ImpactCellViewModel.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

struct ImpactCellViewModel {
    let title: String
    let subtitle: String
    let image: UIImage
}

extension ImpactCellViewModel {
    /// This initializer allows for easy initialization of an impact cell
    /// view model with a weight based statistic
    /// - Parameters:
    ///   - grams: The weight of the statistic in grams as an Int
    ///   - unit: The desired display unit
    ///   - subtitle: A description of the statistic displayed
    ///   - image: An corresponding image to display with the statistic
    init(withAmount grams: Int,
         convertedTo unit: UnitMass,
         subtitle: String,
         image: UIImage) {
        let weightGrams = Measurement(value: Double(grams), unit: UnitMass.grams)
        self.title = weightGrams.converted(to: unit).string
        self.subtitle = subtitle
        self.image = image
    }
}
