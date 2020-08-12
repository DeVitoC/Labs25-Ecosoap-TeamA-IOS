/* GRAPHQL SCHEMA
 type Pickup {
     id: ID!
     confirmationCode: String!
     collectionType: CollectionType!
     status: PickupStatus!
     readyDate: Date!
     pickupDate: Date
     property: Property!
     cartons: [PickupCarton!]!
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


struct Pickup: Identifiable {
    let id: Int
    let confirmationCode: String
    let collectionType: CollectionType
    let status: Status
    let readyDate: Date
    let pickupDate: Date?
    let cartons: [Carton]
    let notes: String
}


extension Pickup {
    enum Status: String {
        case submitted = "SUBMITTED"
        case outForPickup = "OUT_FOR_PICKUP"
        case complete = "COMPLETE"
        case cancelled = "CANCELLED"
    }

    enum CollectionType: String {
        case courierConsolidated = "COURIER_CONSOLIDATED"
        case courierDirect = "COURIER_DIRECT"
        case generatedLabel = "GENERATED_LABEL"
        case local = "LOCAL"
        case other = "OTHER"
    }

    struct Carton: Identifiable {
        let id: Int
        let contents: CartonContents?

        init(id: Int, product: HospitalityService?, weight: Int?) {
            self.id = id
            if let p = product, let w = weight {
                self.contents = CartonContents(product: p, weight: w)
            } else {
                self.contents = nil
            }
        }
    }

    struct CartonContents: Hashable, Identifiable {
        let product: HospitalityService
        let weight: Int

        var id: Int { self.hashValue }
    }
}
