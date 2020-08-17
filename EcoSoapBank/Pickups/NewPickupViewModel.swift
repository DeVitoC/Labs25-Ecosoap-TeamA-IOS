//
//  NewPickupViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


class NewPickupViewModel {
    @Published private(set) var cartons: [NewCartonViewModel] = []
}

// MARK: - Public

extension NewPickupViewModel {
    func addCarton() {
        cartons.append(.init(carton: .init(product: .soap, weight: 0)))
    }
}
