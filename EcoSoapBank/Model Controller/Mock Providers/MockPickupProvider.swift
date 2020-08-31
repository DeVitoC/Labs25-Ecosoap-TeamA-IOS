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
    func fetchPickups(forPropertyID propertyID: String, _ completion: @escaping ResultHandler<[Pickup]>) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            guard !self.shouldFail else {
                completion(.mockFailure())
                return
            }
            completion(.success(.random()))
        }
    }

    func schedulePickup(
        _ pickupInput: Pickup.ScheduleInput,
        completion: @escaping (Result<Pickup.ScheduleResult, Swift.Error>) -> Void
    ) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
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
            property: .random(withID: input.propertyID)
        )
    }

    static func random() -> Self {
        Pickup(
            base: .random(),
            id: UUID().uuidString,
            confirmationCode: mockConfirmationCode(),
            cartons: .random(),
            property: .random()
        )
    }
}

extension Property: Randomizable {
    static func random() -> Self {
        random(withID: nil)
    }

    static func random(withID id: String?) -> Property {
        Property(id: id ?? UUID().uuidString,
                 name: UUID().uuidString,
                 propertyType: .random(),
                 rooms: Int.random(in: 10...100),
                 services: HospitalityService.allCases,
                 collectionType: .random(),
                 logo: nil,
                 phone: nil,
                 billingAddress: nil,
                 shippingAddress: nil,
                 shippingNote: mockNotes(),
                 notes: mockNotes())
    }
}

extension Pickup.Base: Randomizable {
    static func random() -> Self {
        let status = Pickup.Status.random()
        let daysSinceReady = Int.random(in: -14 ... -2)
        let pickupDate: Date? = {
            switch status {
            case .outForPickup:
                return nil
            case .complete:
                return Date(timeIntervalSinceNow: .days(.random(in: daysSinceReady ... -1)))
            case .cancelled:
                return nil
            case .submitted:
                return nil
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

extension Pickup.ScheduleInput: Randomizable {
    static func random() -> Self {
        Pickup.ScheduleInput(
            base: .random(),
            propertyID: UUID().uuidString,
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

extension Pickup.CartonContents: Randomizable {
    static func random() -> Pickup.CartonContents {
        Pickup.CartonContents(product: .random(), percentFull: .random(in: 1...100))
    }
}

extension Pickup.Carton: Randomizable {
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

extension Property.PropertyType: Randomizable {}
extension HospitalityService: Randomizable {}
extension Pickup.Status: Randomizable {}
extension Pickup.CollectionType: Randomizable {}
