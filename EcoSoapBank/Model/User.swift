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

    func updatingProperty(_ newProperty: Property) -> User {
        var newUser = self
        if let indexToReplace = properties?.firstIndex(where: { $0.id == newProperty.id }), properties != nil {
            newUser.properties?.remove(at: indexToReplace)
            newUser.properties?.insert(newProperty, at: indexToReplace)
        } else {
            newUser.properties = properties ?? []
            newUser.properties?.append(newProperty)
        }
        return newUser
    }
}
