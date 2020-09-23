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
    /// <#Description#>
    /// - Parameters:
    ///   - lhs: <#lhs description#>
    ///   - rhs: <#rhs description#>
    /// - Returns: <#description#>
    static func == (lhs: NewCartonViewModel, rhs: NewCartonViewModel) -> Bool {
        lhs === rhs && lhs.carton == rhs.carton
    }

    /// <#Description#>
    /// - Parameter hasher: <#hasher description#>
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
