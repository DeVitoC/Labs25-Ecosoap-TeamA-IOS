//
//  SchedulePickupViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine


/// Protocol that provides Delegate methods for hte SchedulePickupViewModel
protocol SchedulePickupViewModelDelegate: AnyObject {
    func editCarton(for viewModel: NewCartonViewModel)
    func cancelPickup()
    func schedulePickup(
        for input: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>)
}


/// Creates the View Model that allows a user to Schedule a new **Pickup**
class SchedulePickupViewModel {
    @Published private(set) var cartons: [NewCartonViewModel] = []
    var readyDate: Date = Date()
    var notes: String = ""
    lazy var selectedProperty = properties.first!

    private var user: User
    private weak var delegate: SchedulePickupViewModelDelegate?

    /// Initializes the **SchedulePickupViewModel** with the passed in **User** and optional **SchedulePickupViewModelDelegate**
    /// - Parameters:
    ///   - user: The currently logged in **User**
    ///   - delegate: And optinoal **SchedulePickupViewModelDelegate**
    init(user: User, delegate: SchedulePickupViewModelDelegate?) {
        self.user = user
        self.delegate = delegate
    }
}

// MARK: - Public

extension SchedulePickupViewModel {
    var properties: [Property] { user.properties ?? [] }

    /// Method that will append a new carton to the cartons array. Initializes a default carton of type **Soap** and **0%** full
    func addCarton() {
        cartons.append(.init(carton: .init(product: .soap, percentFull: 0)))
    }

    /// Method that allows a user to edit a carton. Takes in a carton index and calls the editCarton method on the delegate
    /// - Parameter cartonIndex: The **Int** carton index of the **Carton** the user is editing
    func editCarton(atIndex cartonIndex: Int) {
        assert((0..<cartons.count).contains(cartonIndex),
               "Attempted to edit index outside of range for NewPickupViewModel.cartons")
        delegate?.editCarton(for: cartons[cartonIndex])
    }

    /// Method that allows a user to remove a carton. Takes in a carton index and removes the selected carton from the cartons array.
    /// - Parameter cartonIndex: The **Int** carton index of the **Carton** the user is removing
    func removeCarton(atIndex cartonIndex: Int) {
        assert((0..<cartons.count).contains(cartonIndex),
               "Attempted to remove index outside of range for NewPickupViewModel.cartons")
        cartons.remove(at: cartonIndex)
    }

    /// Method that allows a user to schedule a pickup with the current carton and date information
    /// - Parameter completion: A completion that passes on a **ResultHandler** with a **Pickup.ScheduleResults** object of an **Error**
    func schedulePickup(_ completion: ResultHandler<Pickup.ScheduleResult>? = nil) {
        guard let delegate = delegate else {
            if let comp = completion {
                comp(.failure(ESBError.noDelegate))
            }
            return
        }
        delegate.schedulePickup(
            for: Pickup.ScheduleInput(
                base: Pickup.Base(
                    collectionType: selectedProperty.collectionType,
                    status: .submitted,
                    readyDate: readyDate,
                    pickupDate: nil, // TODO: move out of base
                    notes: notes),
                propertyID: selectedProperty.id,
                cartons: cartons.map { $0.carton }),
            completion: completion ?? { _ in })
    }

    /// Method that allows a user to cancel a pickup
    func cancelPickup() {
        delegate?.cancelPickup()
    }
}
