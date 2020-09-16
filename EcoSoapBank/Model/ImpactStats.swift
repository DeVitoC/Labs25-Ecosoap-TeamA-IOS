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

    init(
        soapRecycled: Int? = nil,
        bottlesRecycled: Int? = nil,
        linensRecycled: Int? = nil,
        paperRecycled: Int? = nil,
        peopleServed: Int? = nil,
        womenEmployed: Int? = nil
    ) {
        self.soapRecycled = soapRecycled
        self.bottlesRecycled = bottlesRecycled
        self.linensRecycled = linensRecycled
        self.paperRecycled = paperRecycled
        self.peopleServed = peopleServed
        self.womenEmployed = womenEmployed
    }

    static func + (lhs: ImpactStats, rhs: ImpactStats) -> ImpactStats {
        ImpactStats(
            soapRecycled: lhs.soapRecycled + rhs.soapRecycled,
            bottlesRecycled: lhs.bottlesRecycled + rhs.bottlesRecycled,
            linensRecycled: lhs.linensRecycled + rhs.linensRecycled,
            paperRecycled: lhs.paperRecycled + rhs.paperRecycled,
            peopleServed: lhs.peopleServed + rhs.peopleServed,
            womenEmployed: lhs.womenEmployed + rhs.womenEmployed)
    }
}


private extension Optional where Wrapped == Int {
    static func + (lhs: Int?, rhs: Int?) -> Int? {
        (lhs == nil && rhs == nil) ? nil : (lhs ?? 0) + (rhs ?? 0)
    }
}
