//
//  ImpactStats.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

struct ImpactStats: Decodable {
    
    let allStats: [Statistic]
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case soapRecycled
        case linensRecycled
        case bottlesRecycled
        case paperRecycled
        case peopleServed
        case womenEmployed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var allStats: [Statistic] = []
        
        if let soap: Int = try container.decode(Optional<Int>.self, forKey: .soapRecycled) {
            allStats.append(Statistic.soapRecycled(grams: soap))
        }
        if let linens: Int = try container.decode(Optional<Int>.self, forKey: .linensRecycled) {
            allStats.append(Statistic.linensRecycled(grams: linens))
        }
        if let bottles: Int = try container.decode(Optional<Int>.self, forKey: .bottlesRecycled) {
            allStats.append(Statistic.bottlesRecycled(grams: bottles))
        }
        if let paper: Int = try container.decode(Optional<Int>.self, forKey: .paperRecycled) {
            allStats.append(Statistic.paperRecycled(grams: paper))
        }
        if let people: Int = try container.decode(Optional<Int>.self, forKey: .peopleServed) {
            allStats.append(Statistic.peopleServed(people: people))
        }
        if let women: Int = try container.decode(Optional<Int>.self, forKey: .womenEmployed) {
            allStats.append(Statistic.womenEmployed(women: women))
        }
        
        self.allStats = allStats
    }
    
    enum Statistic {
        case soapRecycled(grams: Int)
        case linensRecycled(grams: Int)
        case bottlesRecycled(grams: Int)
        case paperRecycled(grams: Int)
        case peopleServed(people: Int)
        case womenEmployed(women: Int)
        
        var amountString: String {
            switch self {
            case .soapRecycled(let grams),
                 .linensRecycled(let grams),
                 .bottlesRecycled(let grams),
                 .paperRecycled(let grams):
                // TODO: Convert to appropriate unit(lbs or kg)
                return String(grams)
            case .peopleServed(let people):
                return String(people)
            case .womenEmployed(let women):
                return String(women)
            }
        }
        
        var description: String {
            switch self {
            case .soapRecycled:
                return "soap recycled"
            case .linensRecycled:
                return "linens recycled"
            case .bottlesRecycled:
                return "bottle ammenities recycled"
            case .paperRecycled:
                return "paper recycled"
            case .peopleServed:
                return "people served"
            case .womenEmployed:
                return "women employed"
            }
        }
        
        var image: UIImage {
            // TODO: Get corresponding images from assets
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
}
