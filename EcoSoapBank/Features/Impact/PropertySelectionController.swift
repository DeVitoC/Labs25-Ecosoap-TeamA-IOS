//
//  PropertySelectionController.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class PropertySelectionController {
    let user: User
    
    private(set) var properties: [Property] = []
    private(set) var selectedProperty: Property?
    
    init(user: User) {
        self.user = user
        properties = user.properties ?? []
        selectedProperty = properties.first
    }
}
