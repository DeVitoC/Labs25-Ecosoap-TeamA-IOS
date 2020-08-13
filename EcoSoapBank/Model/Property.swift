/* GRAPHQL SCHEMA (as of 2020-08-07 15:25)
 type Property {
     id: ID!
     name: String!
     propertyType: PropertyType!
     rooms: Int!
     services: [HospitalityService]!
     collectionType: CollectionType!
     logo: Url
     phone: String
     billingAddress: Address
     shippingAddress: Address
     coordinates: Coordinates
     shippingNote: String
     notes: String
     hub: Hub
     impact: ImpactStats
     users: [User]
     pickups: [Pickup]
     contract: HospitalityContract
 }
 */

import Foundation

struct Property: Decodable {
    let id: Int
    let name: String
    let propertyType: PropertyType
    let rooms: Int
    let services: [HospitalityService]
    let collectionType: Pickup.CollectionType
    let logo: URL?
    let phone: String?
    let billingAddress: Address?
    let shippingAddress: Address?
    let coordinates: Coordinate?
    let shippingNote: String?
    let notes: String?
    let impact: ImpactStats?
    let user: [User]?
    let pickups: [Pickup]?
    let contract: HospitalityContract?

    enum PropertyType: String, Decodable {
        case bedAndBreakfast = "BED_AND_BREAKFAST"
        case guesthouse = "GUESTHOUSE"
        case hotel = "HOTEL"
        case other = "OTHER"
    }

    enum BillingMethod: String, Decodable {
        case ach = "ACH"
        case credit = "CREDIT"
        case debit = "DEBIT"
        case invoice = "INVOICE"
    }

    struct HospitalityContract: Decodable {
        let id: Int
        let startDate: Date
        let endDate: Date
        let paymentStartDate: Date
        let paymentEndDate: Date
        let properties: [Property]
        let paymentFrequency: Date
        let price: Int?
        let discount: Float?
        let billingMethod: BillingMethod?
        let automatedBilling: Bool
        let payments: [Payment]?
        let amountPaid: Int?
    }
}

