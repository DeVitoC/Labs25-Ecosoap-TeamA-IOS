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
        _ completion: @escaping ResultHandler<[Pickup]>)

    func schedulePickup(
        _ pickupInput: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>)
}


enum PickupError: Error {
    case noResult
    case noProperties
}


class PickupController: ObservableObject {
    @Published private(set) var pickups: [Pickup] = []

    private(set) var user: User

    private var dataProvider: PickupDataProvider
    private var schedulePickupCancellables: Set<AnyCancellable> = []
    private var cancellables: Set<AnyCancellable> = []

    private static let pickupSorter = sortDescriptor(keypath: \Pickup.readyDate, by: >)

    init(user: User, dataProvider: PickupDataProvider) {
        self.dataProvider = dataProvider
        self.user = user
    }

    @discardableResult
    func fetchAllPickups() -> Future<[Pickup], Error> {
        Future { promise in
            self.dataProvider.fetchAllPickups { [weak self] result in
                if case .success(let pickups) = result {
                    self?.pickups = pickups
                }
                promise(result)
            }
        }
    }

    func schedulePickup(
        for pickupInput: Pickup.ScheduleInput
    ) -> Future<Pickup.ScheduleResult, Error> {
        Future { [unowned self] promise in
            self.dataProvider.schedulePickup(pickupInput) { [weak self] result in
                guard let self = self else { return }
                if case .success(let pickupResult) = result {
                    guard let pickup = pickupResult.pickup else {
                        return promise(.failure(PickupError.noResult))
                    }
                    self.pickups.append(pickup)
                }
                promise(result)
            }
        }
    }

    private func handlePickupFetch(_ newPickups: [Pickup]) {
        pickups = newPickups.sorted(by: Self.pickupSorter)
    }
}
