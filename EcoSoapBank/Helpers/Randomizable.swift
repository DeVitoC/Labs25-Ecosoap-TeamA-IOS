//
//  Randomizable.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-26.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


// Indicates this item can be initialized with a random value.
protocol Randomizable {
    /// Return a random value.
    static func random() -> Self
}

extension Randomizable where Self: CaseIterable, AllCases == [Self] {
    static func random() -> Self {
        allCases[Int.random(in: 0 ..< allCases.count)]
    }
}
