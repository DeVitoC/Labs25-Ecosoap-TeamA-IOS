//
//  CartonViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


class CartonViewModel: ObservableObject, Identifiable {
    @Published var product: HospitalityService
    @Published var quantity: Int

    @Published var editing: Bool = false

    var id: ObjectIdentifier { .init(self) }

    init(product: HospitalityService, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
