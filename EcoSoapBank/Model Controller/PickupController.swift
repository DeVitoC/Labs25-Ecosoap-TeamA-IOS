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
    func fetchPickups(
        forPropertyID propertyID: String,
        _ completion: @escaping ResultHandler<[Pickup]>)

    func schedulePickup(
        _ pickupInput: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>)
}


enum PickupError: Error {
    case noResult
    case noDelegate
    case unknown
}


class PickupController: ObservableObject {
    @Published private(set) var pickups: [Pickup] = []
    var properties: [Property]? {
        user.properties
    }

    private(set) var user: User

    private var dataProvider: PickupDataProvider
    private var schedulePickupCancellables: Set<AnyCancellable> = []
    private var cancellables: Set<AnyCancellable> = []

    init(user: User, dataProvider: PickupDataProvider) {
        self.dataProvider = dataProvider
        self.user = user
    }

    @discardableResult
    func fetchPickups(forPropertyID propertyID: String) -> Future<[Pickup], Error> {
        Future { promise in
            self.dataProvider.fetchPickups(forPropertyID: propertyID) { [weak self] result in
                guard let self = self else { return promise(result) }
                if case .success(let newPickups) = result {
                    var pickupSet = Set(self.pickups)
                    newPickups.forEach { pickupSet.insert($0) }
                    let finalPickups = Array(newPickups).sorted {
                        $0.readyDate > $1.readyDate
                    }
                    DispatchQueue.main.async {
                        self.pickups = finalPickups
                    }
                }
                promise(result)
            }
        }
    }

    func fetchPickupsForAllProperties() -> AnyPublisher<[Pickup], Error> {
        guard let properties = properties, !properties.isEmpty else {
            return Future { $0(.failure(UserError.noProperties)) }
                .eraseToAnyPublisher()
        }
        var futures = properties.map { fetchPickups(forPropertyID: $0.id) }
        var combined = futures.popLast()!.eraseToAnyPublisher()
        while let future = futures.popLast() {
            combined = combined.append(future).eraseToAnyPublisher()
        }
        return combined
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
                    DispatchQueue.main.async { self.pickups.insert(pickup, at: 0) }
                }
                promise(result)
            }
        }
    }
}
