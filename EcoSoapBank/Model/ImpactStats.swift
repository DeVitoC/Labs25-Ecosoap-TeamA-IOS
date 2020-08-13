//
//  ImpactStats.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

struct ImpactStats: Decodable {
    let soapRecycled: Int?
    let bottlesRecycled: Int?
    let linensRecycled: Int?
    let paperRecycled: Int?
    let peopleServed: Int?
    let womenEmployed: Int?
}

struct ImpactCellViewModel {
    let title: String
    let subtitle: String
    let image: UIImage
}

extension ImpactCellViewModel {
    
    init(withAmount grams: Int,
         convertedTo unit: UnitMass,
         subtitle: String,
         image: UIImage) {
        let weightGrams = Measurement(value: Double(grams), unit: UnitMass.grams)
        self.title = MeasurementFormatter.shared.string(from: weightGrams.converted(to: unit))
        self.subtitle = subtitle
        self.image = image
    }
}

extension MeasurementFormatter {
    static let shared = configure(MeasurementFormatter()) {
        $0.numberFormatter.maximumFractionDigits = 2
    }
}
