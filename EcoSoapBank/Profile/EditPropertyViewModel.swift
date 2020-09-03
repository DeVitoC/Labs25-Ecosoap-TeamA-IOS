//
//  EditPropertyViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


class EditPropertyViewModel: ObservableObject, Identifiable {
    @Published var propertyInfo: EditablePropertyInfo
    @Published var useShippingAddressForBilling: Bool = false
    var property: Property

    var id: String { property.id }
    let propertyTypes: [Property.PropertyType] = Property.PropertyType.allCases
    
    init(_ property: Property) {
        self.propertyInfo = EditablePropertyInfo(property)
        self.property = property
    }

    func commitChanges() {
        
    }
}


struct EditablePropertyInfo {
    var name: String
    var type: Property.PropertyType
    var billingAddress: EditableAddressInfo
    var shippingAddress: EditableAddressInfo
    var phone: String

    init(_ property: Property?) {
        self.name = property?.name ?? ""
        self.type = property?.propertyType ?? .hotel
        self.billingAddress = EditableAddressInfo(property?.billingAddress)
        self.shippingAddress = EditableAddressInfo(property?.shippingAddress)
        self.phone = property?.phone ?? ""
    }
}

struct EditableAddressInfo {
    var address1: String
    var address2: String
    var address3: String
    var city: String
    var state: String
    var postalCode: String
    var country: String

    init(_ address: Address?) {
        self.address1 = address?.address1 ?? ""
        self.address2 = address?.address2 ?? ""
        self.address3 = address?.address3 ?? ""
        self.city = address?.city ?? ""
        self.state = address?.state ?? ""
        self.postalCode = address?.postalCode ?? ""
        self.country = address?.country ?? ""
    }
}
