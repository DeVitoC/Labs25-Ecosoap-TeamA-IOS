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


struct Pickup: Identifiable, PickupBaseContainer {
    let base: Base

    let id: UUID
    let confirmationCode: String
    let cartons: [Carton]
}

// MARK: - SubTypes

extension Pickup: Decodable {

    struct Base: Equatable, Decodable {
        let collectionType: CollectionType
        let status: Status
        let readyDate: Date
        let pickupDate: Date?
        let notes: String
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
    }

    struct CartonContents: Hashable, Identifiable, Decodable {
        var product: HospitalityService
        var weight: Int

        var id: Int { self.hashValue }
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
    var notes: String { base.notes }
}

// MARK: - Convenience Extensions

extension Pickup.Status {
    var color: Color {
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
