//
//  User.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum UserError: Error {
    case noProperties
}

struct User: Codable, Equatable {
    let id: String
    let firstName: String
    let middleName: String?
    let lastName: String
    let title: String?
    let company: String?
    let email: String
    let phone: String?
    let skype: String?
    private(set) var properties: [Property]?

    mutating func updateProperty(_ newProperty: Property) {
        guard let indexToReplace = properties?.firstIndex(where: {
            $0.id == newProperty.id
        }), properties != nil else {
            properties = properties ?? []
            properties?.append(newProperty)
            return
        }
        properties?.remove(at: indexToReplace)
        properties?.insert(newProperty, at: indexToReplace)
    }
}
