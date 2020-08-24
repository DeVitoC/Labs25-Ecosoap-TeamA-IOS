//
//  MockPickupProvider.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-11.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


/// For placeholder and testing purposes.
class MockPickupProvider {
    /// Set to `true` for testing networking failures
    var shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
}


extension MockPickupProvider: PickupDataProvider {
    /// Simply returns mock Pickups through closure
    /// (or `MockPickupProvider.Error.shouldFail` if `shouldFail` instance property is set to `true`).
    func fetchAllPickups(_ completion: @escaping (Result<[Pickup], Swift.Error>) -> Void) {
        guard !shouldFail else {
            completion(.mockFailure())
            return
        }
        completion(.success(.random()))
    }

    func schedulePickup(
        _ pickupInput: Pickup.ScheduleInput,
        completion: @escaping (Result<Pickup.ScheduleResult, Swift.Error>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard !self.shouldFail else {
                completion(.mockFailure())
                return
            }
            completion(.success(.mock(from: pickupInput)))
        }
    }
}

// MARK: - Convenience Extensions

extension Array where Element == Pickup {
    static func random() -> [Pickup] {
        (3...20).map { _ in Pickup.random() }
    }
}

extension Array where Element == Pickup.CartonContents {
    static func random() -> [Pickup.CartonContents] {
        (0 ... .random(in: 1...4)).map { _ in
            Pickup.CartonContents.random()
        }
    }
}

extension Array where Element == Pickup.Carton {
    static func random() -> [Pickup.Carton] {
        [Pickup.CartonContents].random().map {
            Pickup.Carton(id: UUID().uuidString, contents: $0)
        }
    }
}

extension Pickup {
    /// Uses input `base` to construct data from mock "server."
    static func mock(from input: ScheduleInput) -> Self {
        Pickup(
            base: input.base,
            id: UUID().uuidString,
            confirmationCode: mockConfirmationCode(),
            cartons: input.cartons.map {
                Pickup.Carton(id: UUID().uuidString, contents: $0)
            },
            property: Property(id: "4",
                               name: "Hilton",
                               propertyType: .guesthouse,
                               rooms: 2,
                               services: [],
                               collectionType: .local,
                               logo: nil,
                               phone: nil,
                               billingAddress: nil,
                               shippingAddress: nil,
                               shippingNote: nil,
                               notes: nil)
        )
    }

    static func random() -> Self {
        Pickup(
            base: .random(),
            id: UUID().uuidString,
            confirmationCode: mockConfirmationCode(),
            cartons: .random(),
            property: Property(id: "4",
                               name: "Hilton",
                               propertyType: .guesthouse,
                               rooms: 2,
                               services: [],
                               collectionType: .local,
                               logo: nil,
                               phone: nil,
                               billingAddress: nil,
                               shippingAddress: nil,
                               shippingNote: nil,
                               notes: nil)
        )
    }
}

extension Pickup.Base {
    static func random() -> Self {
        let status = Pickup.Status.random()
        let daysSinceReady = Int.random(in: -14 ... -2)
        let pickupDate: Date? = {
            switch status {
            case .outForPickup:
                return Date()
            case .complete:
                return Date(timeIntervalSinceNow: .days(.random(in: daysSinceReady ... -1)))
            case .cancelled:
                return nil
            case .submitted:
                return Bool.random() ?
                    Date(timeIntervalSinceNow: .days(.random(in: 1...10)))
                    : nil
            }
        }()

        return Pickup.Base(
            collectionType: .random(),
            status: status,
            readyDate: Date(timeIntervalSinceNow: .days(daysSinceReady)),
            pickupDate: pickupDate,
            notes: mockNotes())
    }
}

extension HospitalityService {
    init(intValue: Int) {
        switch intValue {
        case 0: self = .bottles
        case 1: self = .linens
        case 2: self = .paper
        case 3: self = .soap
        default: self = .other
        }
    }

    static func random() -> Self { .init(intValue: .random(in: 0...4)) }
}

extension Pickup.CollectionType {
    init(intValue: Int) {
        switch intValue {
        case 0: self = .courierConsolidated
        case 1: self = .courierDirect
        case 2: self = .generatedLabel
        case 3: self = .local
        default: self = .other
        }
    }

    static func random() -> Self { .init(intValue: .random(in: 0...4)) }
}

extension Pickup.Status {
    init(intValue: Int) {
        switch intValue {
        case 0: self = .cancelled
        case 1: self = .complete
        case 2: self = .outForPickup
        default: self = .submitted
        }
    }

    static func random() -> Self { .init(intValue: .random(in: 0...3)) }
}

extension Pickup.ScheduleInput {
    static func random() -> Self {
        Pickup.ScheduleInput(
            base: .random(),
            propertyID: "0",
            cartons: .random())
    }
}

extension Pickup.ScheduleResult {
    static func mock(from input: Pickup.ScheduleInput) -> Self {
        Pickup.ScheduleResult(
            pickup: .mock(from: input),
            labelURL: URL(string: "http://www.google.com")!)
    }
}

extension Pickup.CartonContents {
    static func random() -> Pickup.CartonContents {
        Pickup.CartonContents(product: .random(), percentFull: .random(in: 1...100))
    }
}

extension Pickup.Carton {
    static func random() -> Pickup.Carton {
        Pickup.Carton(id: UUID().uuidString, contents: .random())
    }
}

// swiftlint:disable private_over_fileprivate
fileprivate func mockConfirmationCode() -> String {
    let longCode = UUID().uuidString
    return String(longCode.dropLast(longCode.count - 7))
}

fileprivate func mockNotes() -> String {
    let hasNotes = Bool.random()

    guard hasNotes else { return "" }

    return (1...10).reduce(into: "") { result, _ in
        result += UUID().uuidString
    }
}
