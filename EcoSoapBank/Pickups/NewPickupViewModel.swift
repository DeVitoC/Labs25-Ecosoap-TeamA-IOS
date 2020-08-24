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
    private var editCartonPassthrough = PassthroughSubject<NewCartonViewModel, Never>()
}

// MARK: - Public

extension NewPickupViewModel {
    /// Publishes pickup input when pickup is scheduled by caller of `schedulePickup`.
    var pickupInput: AnyPublisher<Pickup.ScheduleInput, Error> {
        schedulePickupPassthrough.eraseToAnyPublisher()
    }

    var editingCarton: AnyPublisher<NewCartonViewModel, Never> {
        editCartonPassthrough.eraseToAnyPublisher()
    }

    func addCarton() {
        cartons.append(.init(carton: .init(product: .soap, weight: 0)))
    }

    func editCarton(atIndex cartonIndex: Int) {
        assert((0..<cartons.count).contains(cartonIndex),
               "Attempted to edit index outside of range for NewPickupViewModel.cartons")
        editCartonPassthrough.send(cartons[cartonIndex])
    }

    func removeCarton(atIndex cartonIndex: Int) {
        assert((0..<cartons.count).contains(cartonIndex),
               "Attempted to remove index outside of range for NewPickupViewModel.cartons")
        cartons.remove(at: cartonIndex)
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
