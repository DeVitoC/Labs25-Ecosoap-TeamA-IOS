//
//  Address.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/22/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

struct Address: Codable, Equatable, Hashable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String
    let state: String?
    let postalCode: String?
    let country: String
    let formattedAddress: [String]?
}
