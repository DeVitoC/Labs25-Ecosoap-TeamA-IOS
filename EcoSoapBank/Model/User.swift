//
//  User.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

struct User: Decodable {
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
