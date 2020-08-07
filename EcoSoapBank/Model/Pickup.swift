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


/// TEMPORARY: This model will be vastly modified when network model structures are re-confirmed.
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
        case submitted, outForPickup = "out for pickup", complete, cancelled
    }

    struct Carton: Identifiable {
        let id: Int
        let product: HospitalityService?
        let weight: Int?
    }

    enum CollectionType {
        case courierConsolidated
        case courierDirect
        case generatedLabel
        case local
        case other
    }
}
