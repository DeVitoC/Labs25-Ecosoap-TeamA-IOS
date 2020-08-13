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
