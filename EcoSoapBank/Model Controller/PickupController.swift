//
//  PickupController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


class PickupController: ObservableObject {
    @Published var pickups: [Pickup] = .mockData()
}


extension Array where Element == Pickup {
    static func mockData() -> Self {
        [
            Pickup(
                id: 0,
                confirmationCode: UUID().uuidString,
                collectionType: .generatedLabel,
                status: .complete,
                readyDate: Date(timeIntervalSinceNow: .days(-10)),
                pickupDate: Date(timeIntervalSinceNow: .days(-5)),
                cartons: [
                    .init(id: 0, product: .bottles, weight: 20),],
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
        ]
    }
}
