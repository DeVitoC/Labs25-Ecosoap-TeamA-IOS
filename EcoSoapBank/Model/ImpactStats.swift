//
//  ImpactStats.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

struct ImpactStats {
    
    let stats: [Statistic: Int]

    enum Statistic: String, CodingKey, CaseIterable {
        case soapRecycled
        case linensRecycled
        case bottlesRecycled
        case paperRecycled
        case peopleServed
        case womenEmployed
        
        var description: String {
            switch self {
            case .soapRecycled:
                return "soap recycled"
            case .linensRecycled:
                return "linens recycled"
            case .bottlesRecycled:
                return "bottle amenities/nrecycled"
            case .paperRecycled:
                return "paper recycled"
            case .peopleServed:
                return "people served"
            case .womenEmployed:
                return "women employed"
            }
        }
        
        var image: UIImage {
            switch self {
            case .soapRecycled:
                return UIImage(named: "Bottles")!
            case .linensRecycled:
                return UIImage(named: "Bottles")!
            case .bottlesRecycled:
                return UIImage(named: "Bottles")!
            case .paperRecycled:
                return UIImage(named: "Bottles")!
            case .peopleServed:
                return UIImage(named: "Bottles")!
            case .womenEmployed:
                return UIImage(named: "Bottles")!
            }
        }
    }
    
    func amountString(for stat: Statistic) -> String? {
        if let amount = stats[stat] {
            return String(amount)
        } else {
            return nil
        }
    }
}

extension ImpactStats: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Statistic.self)
        
        stats = Dictionary(uniqueKeysWithValues:
            try Statistic.allCases.compactMap {
                if let value = try container.decode(Optional<Int>.self, forKey: $0) {
                    return ($0, value)
                } else {
                    return nil
                }
            }
        )
    }
}
