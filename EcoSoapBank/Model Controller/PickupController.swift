//
//  PickupController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


protocol PickupDataProvider {
    func fetchAllPickups(_ completion: (Result<[Pickup], Error>) -> Void)
}


class PickupController: ObservableObject {
    @Published private(set) var pickups: [Pickup] = []
    @Published private(set) var error: Error?

    private var dataProvider: PickupDataProvider

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
}


// MARK: - Mock Data Provider

/// For placeholder and testing purposes.
struct MockPickupProvider: PickupDataProvider {
    enum Error: Swift.Error {
        case shouldFail
    }

    /// Set to `true` for testing networking failures
    var shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    /// Simply returns mock Pickups through closure
    /// (or `MockPickupProvider.Error.shouldFail` if `shouldFail` instance property is set to `true`).
    func fetchAllPickups(_ completion: (Result<[Pickup], Swift.Error>) -> Void) {
        guard !shouldFail else {
            completion(.failure(Self.Error.shouldFail))
            return
        }
        completion(.success([
            Pickup(
                id: 0,
                confirmationCode: UUID().uuidString,
                collectionType: .generatedLabel,
                status: .complete,
                readyDate: Date(timeIntervalSinceNow: .days(-10)),
                pickupDate: Date(timeIntervalSinceNow: .days(-5)),
                cartons: [
                    .init(id: 0, product: .bottles, weight: 20), ],
                notes: "notes"),
            Pickup(
                id: 1,
                confirmationCode: UUID().uuidString,
                collectionType: .local,
                status: .outForPickup,
                readyDate: Date(timeIntervalSinceNow: .days(-3)),
                pickupDate: Date(timeIntervalSinceNow: 3600),
                cartons: [
                    .init(id: 1, product: .bottles, weight: 123),
                    .init(id: 2, product: .soap, weight: 93)],
                notes: "otnuhnotehunohuntoheu"),
            Pickup(
                id: 2,
                confirmationCode: UUID().uuidString,
                collectionType: .generatedLabel,
                status: .submitted,
                readyDate: Date(timeIntervalSinceNow: .days(-10)),
                pickupDate: nil,
                cartons: [
                    .init(id: 0, product: .linens, weight: 20),
                    .init(id: 4, product: .other, weight: 98)],
                notes: ""),
        ]))
    }
}
