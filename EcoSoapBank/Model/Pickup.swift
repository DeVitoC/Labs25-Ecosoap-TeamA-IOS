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

    let id: String
    let confirmationCode: String
    let cartons: [Carton]
    let property: Property

    internal init(base: Pickup.Base, id: String, confirmationCode: String, cartons: [Pickup.Carton], property: Property) {
        self.base = base
        self.id = id
        self.confirmationCode = confirmationCode
        self.cartons = cartons
        self.property = property
    }

    static func == (lhs: Pickup, rhs: Pickup) -> Bool {
        lhs.id == rhs.id
            && lhs.confirmationCode == rhs.confirmationCode
            && lhs.property.id == rhs.property.id
    }

    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()
}

// MARK: - SubTypes

extension Pickup {

    struct Base: Equatable, Codable {
        let collectionType: CollectionType
        let status: Status
        let readyDate: Date
        let pickupDate: Date?
        let notes: String?
    }

    // MARK: Schedule I/O

    struct ScheduleInput: PickupBaseContainer, Encodable {
        let base: Base

        let propertyID: String
        let cartons: [CartonContents]

        var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-mm-dd"
            return formatter
        }()

        func encode(to encoder: Encoder) throws {
            // Encode top level values to JSON
            var container = encoder.container(keyedBy: PickupKeys.self)
            try container.encode(collectionType, forKey: .collectionType)
            try container.encode(status, forKey: .status)
            // Encode and convert dates to Date
            try container.encode(formatter.string(from: self.readyDate), forKey: .readyDate)
            if let pickupDate = self.pickupDate {
                try container.encode(formatter.string(from: pickupDate), forKey: .pickupDate)
            }
            try container.encode(propertyID, forKey: .propertyId)
            try container.encodeIfPresent(notes, forKey: .notes)

            //Encode Cartons in Carton container
            try container.encode(cartons, forKey: .cartons)
        }
    }

    struct ScheduleResult: Decodable {
        let pickup: Pickup?
        let labelURL: URL?

        // swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case pickup
            case labelURL = "label"
        }
        // swiftling:enable nesting
    }

    struct Carton: Identifiable, Decodable {
        let id: String
        let contents: CartonContents?

        internal init(id: String, contents: Pickup.CartonContents?) {
            self.id = id
            self.contents = contents
        }

        // Decode Carton and CartonContents
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CartonKeys.self)
            let id = try container.decode(String.self, forKey: .id)
            let product = try container.decodeIfPresent(HospitalityService.self, forKey: .product)
            let percentFull = try container.decodeIfPresent(Int.self, forKey: .percentFull)

            // Create the CartonContents object
            let cartonContents = CartonContents(product: product ?? HospitalityService.other, percentFull: percentFull ?? 0)

            self.id = id
            self.contents = cartonContents
        }
    }

    struct CartonContents: Hashable, Codable {
        var product: HospitalityService
        var percentFull: Int

        var id: Int { self.hashValue }
    }

    // MARK: Enums

    enum Status: String, Codable {
        case submitted = "SUBMITTED"
        case outForPickup = "OUT_FOR_PICKUP"
        case complete = "COMPLETE"
        case cancelled = "CANCELLED"
    }

    enum CollectionType: String, Codable {
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
        case percentFull
    }
}

extension Pickup: Decodable {

    // Decodes Pickup and the base object
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PickupKeys.self)

        // Decodes all top level values from JSON
        let id = try container.decode(String.self, forKey: .id)
        let confirmationCode = try container.decode(String.self, forKey: .confirmationCode)
        let collectionType = try container.decode(CollectionType.self, forKey: .collectionType)
        let status = try container.decode(Status.self, forKey: .status)

        // Decode and convert Date string to Date.
        let readyDateString = try container.decode(String.self, forKey: .readyDate)
        var readyDate: Date = Date()
        if let readyDate1 = formatter.date(from: readyDateString) {
            readyDate = readyDate1
        } else {
            let year = readyDateString.dropLast(4)
            let month = readyDateString.dropFirst(4).dropLast(2)
            let day = readyDateString.dropFirst(6)
            if let readyDate2 = formatter.date(from: "\(year)-\(month)-\(day)") {
                readyDate = readyDate2
            }
        }

        let pickupDateString = try container.decodeIfPresent(String.self, forKey: .pickupDate)
        var pickupDate: Date?
        if let pickupDateStringUnwrapped = pickupDateString {
            pickupDate = formatter.date(from: pickupDateStringUnwrapped)
        }
        let property = try container.decode(Property.self, forKey: .property)
        let notes = try container.decodeIfPresent(String.self, forKey: .notes)

        // Decodes Cartons based on Carton decoder
        var cartonsArrayContainer = try container.nestedUnkeyedContainer(forKey: .cartons)
        let cartonsDict = try cartonsArrayContainer.decode(Pickup.Carton.self)

        let base = Base(collectionType: collectionType, status: status, readyDate: readyDate, pickupDate: pickupDate, notes: notes)

        self.base = base
        self.cartons = [cartonsDict]
        self.id = id
        self.property = property
        self.confirmationCode = confirmationCode
    }

//    func encode(to encoder: Encoder) throws {
//        // Encode top level values to JSON
//        var container = encoder.container(keyedBy: PickupKeys.self)
//        try container.encode(collectionType, forKey: .collectionType)
//        try container.encode(id, forKey: .id)
//        try container.encode(confirmationCode, forKey: .confirmationCode)
//        try container.encode(collectionType, forKey: .collectionType)
//        try container.encode(status, forKey: .status)
//        // Encode and convert dates to Date
//        try container.encode(formatter.string(from: self.readyDate), forKey: .readyDate)
//        if let pickupDate = self.pickupDate {
//            try container.encode(formatter.string(from: pickupDate), forKey: .pickupDate)
//        }
//        try container.encode(property, forKey: .property)
//        try container.encodeIfPresent(notes, forKey: .notes)
//
//        //Encode Cartons in Carton container
//        var cartonContainer = container.nestedUnkeyedContainer(forKey: .cartons)
//        try cartonContainer.encode(cartons)
//    }
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
            return .systemBlue
        case .outForPickup:
            return .systemOrange
        case .complete:
            return .esbGreen
        case .cancelled:
            return .systemRed
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
    var display: String { "\(product.rawValue.capitalized): \(percentFull)g" }
}
