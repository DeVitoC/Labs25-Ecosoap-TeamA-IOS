//
//  PickupController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine


protocol PickupDataProvider {
    func fetchAllPickups(
        _ completion: @escaping (Result<[Pickup], Error>) -> Void)

    func schedulePickup(
        _ pickupInput: Pickup.ScheduleInput,
        completion: @escaping (Result<Pickup.ScheduleResult, Error>) -> Void)
}


class PickupController: ObservableObject {
    @Published private(set) var pickups: [Pickup] = []
    @Published private(set) var error: Error?

    private var dataProvider: PickupDataProvider

    private var newPickupViewModel: NewPickupViewModel?

    init(dataProvider: PickupDataProvider) {
        self.dataProvider = dataProvider

        self.dataProvider.fetchAllPickups { [weak self] result in
            switch result {
            case .success(let pickups):
                self?.pickups = pickups
            case .failure(let error):
                self?.error = error
            }
        }
    }

    /// Returns a view model for use with new pickup views.
    ///
    /// The PickupController holds a reference to the view model for later reuse and/or for use with SwiftUI
    /// (where views may inadvertantly reinitialize objects if a reference is not held elsewhere).
    func viewModelForNewPickup() -> NewPickupViewModel {
        if let vm = newPickupViewModel {
            return vm
        }
        newPickupViewModel = NewPickupViewModel()
        return newPickupViewModel!
    }

    func schedulePickup(
        _ pickupInput: Pickup.ScheduleInput,
        completion: @escaping (Result<Pickup.ScheduleResult, Error>) -> Void
    ) {
        self.dataProvider.schedulePickup(pickupInput) { result in
            switch result {
            case .success(let pickupResult):
                self.pickups.append(pickupResult.pickup)
                completion(result)
            case .failure(let error):
                self.error = error
                completion(result)
            }
        }
    }

    func clearError() {
        error = nil
    }
}
