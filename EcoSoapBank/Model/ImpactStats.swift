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

    init(soapRecycled: Int? = nil,
         bottlesRecycled: Int? = nil,
         linensRecycled: Int? = nil,
         paperRecycled: Int? = nil,
         peopleServed: Int? = nil,
         womenEmployed: Int? = nil) {
        self.soapRecycled = soapRecycled
        self.bottlesRecycled = bottlesRecycled
        self.linensRecycled = linensRecycled
        self.paperRecycled = paperRecycled
        self.peopleServed = peopleServed
        self.womenEmployed = womenEmployed
    }
}
