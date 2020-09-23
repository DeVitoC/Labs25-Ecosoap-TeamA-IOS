//
//  NewCartonViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


class NewCartonViewModel {
    @Published var carton: Pickup.CartonContents

    init(carton: Pickup.CartonContents) {
        self.carton = carton
    }
}

extension NewCartonViewModel: Hashable {
    static func == (lhs: NewCartonViewModel, rhs: NewCartonViewModel) -> Bool {
        lhs === rhs && lhs.carton == rhs.carton
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
