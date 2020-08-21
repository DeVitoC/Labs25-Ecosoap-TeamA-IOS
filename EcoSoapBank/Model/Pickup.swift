/* GRAPHQL SCHEMA
 type Pickup {
     id: ID!
     confirmationCode: String!
     collectionType: CollectionType!**
     status: PickupStatus!**
     readyDate: Date!**
     pickupDate: Date**
     property: Property!^^
     cartons: [PickupCarton!]!^^
     notes: String**
 }

 type SchedulePickupInput {
     collectionType: CollectionType!
     status: PickupStatus!
     readyDate: Date!
     pickupDate: Date
     propertyId: ID!
     cartons: [PickupCartonInput!]!
     notes: String
 }

 enum PickupStatus {
     SUBMITTED
     OUT_FOR_PICKUP
     COMPLETE
     CANCELLED
 }

 type PickupCarton {
     id: ID!
     product: HospitalityService
     weight: Int
 }

 input PickupCartonInput {
     product: HospitalityService
     weight: Int
 }

 enum CollectionType {
     COURIER_CONSOLIDATED
     COURIER_DIRECT
     GENERATED_LABEL
     LOCAL
     OTHER
 }
 */

import SwiftUI
import UIKit


struct Pickup: Identifiable, PickupBaseContainer, Equatable {
    let base: Base

    let id: UUID
    let confirmationCode: String
    let cartons: [Carton]
    let property: Property

    internal init(base: Pickup.Base, id: UUID, confirmationCode: String, cartons: [Pickup.Carton], property: Property) {
        self.base = base
        self.id = id
        self.confirmationCode = confirmationCode
        self.cartons = cartons
        self.property = property
    }

    // Decodes Pickup and the base object
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PickupKeys.self)

        // Decodes all top level values from JSON
        let id = try container.decode(UUID.self, forKey: .id)
        let confirmationCode = try container.decode(String.self, forKey: .confirmationCode)
        let collectionType = try container.decode(CollectionType.self, forKey: .collectionType)
        let status = try container.decode(Status.self, forKey: .status)
        let readyDate = try container.decode(Date.self, forKey: .readyDate)
        let pickupDate = try container.decodeIfPresent(Date.self, forKey: .pickupDate)
        let property = try container.decode(Property.self, forKey: .property)
        let notes = try container.decodeIfPresent(String.self, forKey: .notes)

        // Decodes Cartons based on Carton decoder
        var cartonsArrayContainer = try container.nestedUnkeyedContainer(forKey: .cartons)
        let cartons = try cartonsArrayContainer.decode([Carton].self)

        let base = Base(collectionType: collectionType, status: status, readyDate: readyDate, pickupDate: pickupDate, notes: notes)

        self.base = base
        self.cartons = cartons
        self.id = id
        self.property = property
        self.confirmationCode = confirmationCode
    }

    static func == (lhs: Pickup, rhs: Pickup) -> Bool {
        lhs.id == rhs.id
            && lhs.confirmationCode == rhs.confirmationCode
            && lhs.property.id == rhs.property.id
    }
}

// MARK: - SubTypes

extension Pickup: Decodable {

    struct Base: Equatable, Decodable {
        let collectionType: CollectionType
        let status: Status
        let readyDate: Date
        let pickupDate: Date?
        let notes: String?
    }

    // MARK: Schedule I/O

    struct ScheduleInput: PickupBaseContainer {
        let base: Base

        let propertyID: UUID
        let cartons: [CartonContents]
    }

    struct ScheduleResult {
        let pickup: Pickup
        let labelURL: URL
    }

    struct Carton: Identifiable, Decodable {
        let id: UUID
        let contents: CartonContents?

        internal init(id: UUID, contents: Pickup.CartonContents?) {
            self.id = id
            self.contents = contents
        }

        // Decode Carton and CartonContents
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CartonKeys.self)
            let id = try container.decode(UUID.self, forKey: .id)
            let product = try container.decodeIfPresent(HospitalityService.self, forKey: .product)
            let weight = try container.decodeIfPresent(Int.self, forKey: .weight)

            // Create the CartonContents object
            let cartonContents = CartonContents(product: product ?? HospitalityService.other, weight: weight ?? 0)

            self.id = id
            self.contents = cartonContents
        }
    }

    struct CartonContents: Hashable, Decodable {
        var product: HospitalityService
        var weight: Int
    }

    // MARK: Enums

    enum Status: String, Decodable {
        case submitted = "SUBMITTED"
        case outForPickup = "OUT_FOR_PICKUP"
        case complete = "COMPLETE"
        case cancelled = "CANCELLED"
    }

    enum CollectionType: String, Decodable {
        case courierConsolidated = "COURIER_CONSOLIDATED"
        case courierDirect = "COURIER_DIRECT"
        case generatedLabel = "GENERATED_LABEL"
        case local = "LOCAL"
        case other = "OTHER"
    }

    enum PickupKeys: CodingKey {
        case id
        case confirmationCode
        case collectionType
        case status
        case readyDate
        case pickupDate
        case property
        case cartons
        case notes
    }

    enum CartonKeys: CodingKey {
        case id
        case product
        case weight
    }
}

// MARK: Base Container Protocol

protocol PickupBaseContainer {
    var base: Pickup.Base { get }
}

extension PickupBaseContainer {
    var collectionType: Pickup.CollectionType { base.collectionType }
    var status: Pickup.Status { base.status }
    var readyDate: Date { base.readyDate }
    var pickupDate: Date? { base.pickupDate }
    var notes: String { base.notes ?? "" }
}

// MARK: - Convenience Extensions

extension Pickup.Status {
    var color: UIColor {
        switch self {
        case .submitted:
            return .blue
        case .outForPickup:
            return .purple
        case .complete:
            return .green
        case .cancelled:
            return .gray
        }
    }

    var display: String {
        switch self {
        case .outForPickup: return "Out for Pickup"
        default: return rawValue.lowercased().capitalized
        }
    }
}

extension Pickup.Carton {
    var display: String? { contents?.display }
}

extension Pickup.CartonContents {
    var display: String { "\(product.rawValue.capitalized): \(weight)g" }
}
