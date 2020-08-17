//
//  User.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

struct User: Decodable {
    internal init(id: Int,
                  firstName: String,
                  middleName: String,
                  lastName: String,
                  title: String,
                  company: String,
                  email: String,
                  phone: String,
                  skype: String,
                  properties: [Property]) {
        self.id = id
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.title = title
        self.company = company
        self.email = email
        self.phone = phone
        self.skype = skype
        self.properties = properties
    }
    
    let id: Int
    let firstName: String
    let middleName: String
    let lastName: String
    let title: String
    let company: String
    let email: String
    let phone: String
    let skype: String
    let properties: [Property]
}
