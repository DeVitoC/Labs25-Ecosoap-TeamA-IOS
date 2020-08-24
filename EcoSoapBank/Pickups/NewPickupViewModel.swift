//
//  NewPickupViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine


class NewPickupViewModel {
    @Published private(set) var cartons: [NewCartonViewModel] = []
    @Published var readyDate: Date = Date()
    @Published var notes: String = ""

    private var schedulePickupPassthrough = PassthroughSubject<Pickup.ScheduleInput, Error>()
}

// MARK: - Public

extension NewPickupViewModel {
    /// Publishes pickup input when pickup is scheduled by caller of `schedulePickup`.
    var pickupInput: AnyPublisher<Pickup.ScheduleInput, Error> {
        schedulePickupPassthrough.eraseToAnyPublisher()
    }

    func addCarton() {
        cartons.append(.init(carton: .init(product: .soap, percentFull: 0)))
    }

    func removeCarton(at index: Int) {
        assert((0..<cartons.count).contains(index),
               "Attempted to remove index outside of range for NewPickupViewModel.cartons")
        cartons.remove(at: index)
    }

    func schedulePickup() {
        schedulePickupPassthrough.send(Pickup.ScheduleInput(
            base: Pickup.Base(
                collectionType: .generatedLabel, // TODO: actual value
                status: .submitted,
                readyDate: readyDate,
                pickupDate: nil, // TODO: move out of base
                notes: notes),
            propertyID: UUID(), // TODO: actual value
            cartons: cartons.map { $0.carton }))
    }
}
