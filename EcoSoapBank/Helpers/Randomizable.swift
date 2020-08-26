//
//  Randomizable.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-26.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

protocol Randomizable {
    static func random() -> Self
}

extension Randomizable where Self: CaseIterable, AllCases == [Self] {
    static func random() -> Self {
        allCases[Int.random(in: 0 ..< allCases.count)]
    }
}
