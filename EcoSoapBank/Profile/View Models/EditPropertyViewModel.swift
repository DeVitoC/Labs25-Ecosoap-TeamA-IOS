//
//  EditPropertyViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Combine
import SwiftUI


class EditPropertyViewModel: ObservableObject, Identifiable {
    @Published var propertyInfo: EditablePropertyInfo
    @Published var useShippingAddressForBilling: Bool = false
    @Published var error: Error?
    @Binding var isActive: Bool
    lazy var didFail = Binding(
        get: { [weak self] in self?.error != nil },
        set: { [weak self] newFail in if !newFail { self?.error = nil } })
    let property: Property

    var id: String { property.id }
    let propertyTypes: [Property.PropertyType] = Property.PropertyType.allCases

    private let userController: UserController
    
    init(_ property: Property, isActive: Binding<Bool>, userController: UserController) {
        self.propertyInfo = EditablePropertyInfo(property)
        self.property = property
        self._isActive = isActive
        self.userController = userController
    }

    func commitChanges() {
    }
}
