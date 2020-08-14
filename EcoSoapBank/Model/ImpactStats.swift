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

    init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: ImpactStatsQueryKeys.self)
        let impactStatsContainer = try? container?.nestedContainer(keyedBy: ImpactStatsKeys.self, forKey: .impactStatsByPropertyId)

        let soapRecycled = try? impactStatsContainer?.decodeIfPresent(Int.self, forKey: .soapRecycled)
        let bottlesRecycled = try? impactStatsContainer?.decodeIfPresent(Int.self, forKey: .bottlesRecycled)
        let linensRecycled = try? impactStatsContainer?.decodeIfPresent(Int.self, forKey: .linensRecycled)
        let paperRecycled = try? impactStatsContainer?.decodeIfPresent(Int.self, forKey: .paperRecycled)
        let peopleServed = try? impactStatsContainer?.decodeIfPresent(Int.self, forKey: .peopleServed)
        let womenEmployed = try? impactStatsContainer?.decodeIfPresent(Int.self, forKey: .womenEmployed)

        self.soapRecycled = soapRecycled
        self.bottlesRecycled = bottlesRecycled
        self.linensRecycled = linensRecycled
        self.paperRecycled = paperRecycled
        self.peopleServed = peopleServed
        self.womenEmployed = womenEmployed
    }

    enum ImpactStatsKeys: CodingKey {
        case soapRecycled
        case bottlesRecycled
        case linensRecycled
        case paperRecycled
        case peopleServed
        case womenEmployed
    }

    enum ImpactStatsQueryKeys: CodingKey {
        case impactStatsByPropertyId
    }
}
