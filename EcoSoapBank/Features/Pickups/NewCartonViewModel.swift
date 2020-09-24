//
//  NewCartonViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


/// The ViewModel that controlls the individual Cartons in the SchedulePickupViewModel
class NewCartonViewModel {
    @Published var carton: Pickup.CartonContents

    /// Initializes a **Carton** with the contents entered
    /// - Parameter carton: **Pickup.CartonContents** object with the type and percent full of the carton to initialize
    init(carton: Pickup.CartonContents) {
        self.carton = carton
    }
}

extension NewCartonViewModel: Hashable {
    /// Defines how "==" works for comparing **NewCartonViewModels**.
    /// Compares if both are the same object (===) and also that the carton property is the same for both
    /// Required for conformance to Hashable
    /// - Parameters:
    ///   - lhs: The **NewCartonViewModel** on the left side of the "=="
    ///   - rhs: The **newCartonViewModel** on the right side of the "=="
    /// - Returns: Returns **true** if the two **NewCartonViewModels** are the same object and **false** if they are not.
    static func == (lhs: NewCartonViewModel, rhs: NewCartonViewModel) -> Bool {
        lhs === rhs && lhs.carton == rhs.carton
    }

    /// Conforms the **NewCartonViewModel** to Hashable
    /// - Parameter hasher: The **Hasher** object to be hashed
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
