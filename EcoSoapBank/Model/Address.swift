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

struct EditableAddressInfo: Encodable, Equatable {
    var address1: String
    var address2: String
    var address3: String
    var city: String
    var state: String
    var postalCode: String
    var country: String

    init(_ address: Address? = nil) {
        self.address1 = address?.address1 ?? ""
        self.address2 = address?.address2 ?? ""
        self.address3 = address?.address3 ?? ""
        self.city = address?.city ?? ""
        self.state = address?.state ?? ""
        self.postalCode = address?.postalCode ?? ""
        self.country = address?.country ?? ""
    }
}
