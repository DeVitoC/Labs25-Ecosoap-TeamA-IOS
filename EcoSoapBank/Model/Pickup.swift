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

import Foundation


struct Pickup: Identifiable, PickupBaseContainer {
    let base: Base

    let id: UUID
    let confirmationCode: String
    let cartons: [Carton]
}

// MARK: - SubTypes

extension Pickup {
    struct Base {
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

    struct Carton: Identifiable {
        let id: UUID
        let contents: CartonContents?
    }

    struct CartonContents: Hashable, Identifiable {
        let product: HospitalityService
        let weight: Int

        var id: Int { self.hashValue }
    }

    // MARK: Enums

    enum Status: String {
        case submitted, outForPickup = "out for pickup", complete, cancelled
    }

    enum CollectionType {
        case courierConsolidated
        case courierDirect
        case generatedLabel
        case local
        case other
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
}
