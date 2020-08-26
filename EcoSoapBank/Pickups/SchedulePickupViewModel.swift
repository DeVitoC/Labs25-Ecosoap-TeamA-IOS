//
//  SchedulePickupViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine


protocol SchedulePickupViewModelDelegate: AnyObject {
    func schedulePickup(
        for input: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>)
    func editCarton(for viewModel: NewCartonViewModel)
}


class SchedulePickupViewModel {
    @Published private(set) var cartons: [NewCartonViewModel] = []
    var readyDate: Date = Date()
    var notes: String = ""
    lazy var selectedProperty = properties.first!

    private var user: User
    private weak var delegate: SchedulePickupViewModelDelegate?

    init(user: User, delegate: SchedulePickupViewModelDelegate?) {
        self.user = user
        self.delegate = delegate
    }
}

// MARK: - Public

extension SchedulePickupViewModel {
    var properties: [Property] { user.properties ?? [] }

    func addCarton() {
        cartons.append(.init(carton: .init(product: .soap, percentFull: 0)))
    }

    func editCarton(atIndex cartonIndex: Int) {
        assert((0..<cartons.count).contains(cartonIndex),
               "Attempted to edit index outside of range for NewPickupViewModel.cartons")
        delegate?.editCarton(for: cartons[cartonIndex])
    }

    func removeCarton(atIndex cartonIndex: Int) {
        assert((0..<cartons.count).contains(cartonIndex),
               "Attempted to remove index outside of range for NewPickupViewModel.cartons")
        cartons.remove(at: cartonIndex)
    }

    func schedulePickup() {
        delegate?.schedulePickup(
            for: Pickup.ScheduleInput(
                base: Pickup.Base(
                    collectionType: selectedProperty.collectionType,
                    status: .submitted,
                    readyDate: readyDate,
                    pickupDate: nil, // TODO: move out of base
                    notes: notes),
                propertyID: selectedProperty.id,
                cartons: cartons.map { $0.carton }),
            completion: { _ in })
    }
}
