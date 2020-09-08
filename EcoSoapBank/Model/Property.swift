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
import Combine


struct Property: Codable, Equatable, Identifiable, Hashable {
    let id: String
    let name: String
    let propertyType: PropertyType
    let rooms: Int
    let services: [HospitalityService]
    let collectionType: Pickup.CollectionType
    let logo: String?
    let phone: String?
    let billingAddress: Address?
    let shippingAddress: Address?
    let shippingNote: String?
    let notes: String?

    enum PropertyType: String, Codable, CaseIterable, Identifiable, Hashable {
        case bedAndBreakfast = "BED_AND_BREAKFAST"
        case guesthouse = "GUESTHOUSE"
        case hotel = "HOTEL"
        case other = "OTHER"

        var id: String { rawValue }

        var display: String {
            if case .bedAndBreakfast = self {
                return "Bed & Breakfast"
            } else {
                return rawValue.capitalized
            }
        }
    }

    enum BillingMethod: String, Codable, CaseIterable {
        case ach = "ACH"
        case credit = "CREDIT"
        case debit = "DEBIT"
        case invoice = "INVOICE"
    }
}

// MARK: - Property Selection

enum PropertySelection: Hashable {
    case all
    case select(Property)

    var property: Property? {
        if case .select(let property) = self {
            return property
        }
        return nil
    }
    var display: String { property?.name ?? "All" }

    init(_ property: Property?) {
        if let prop = property {
            self = .select(prop)
        } else {
            self = .all
        }
    }
}

extension UserDefaults {
    private static let propertySelectionByUserID = PassthroughSubject<[String: PropertySelection], Never>()

    func selectedPropertyPublisher(forUser user: User) -> AnyPublisher<PropertySelection, Never> {
        UserDefaults.propertySelectionByUserID
            .compactMap({ propertySelectionByUserID -> PropertySelection? in
                if let propertySelection = propertySelectionByUserID[user.id] {
                    return propertySelection
                } else { return nil }
            }).eraseToAnyPublisher()
    }

    var selectedPropertyIDsByUser: [String: String]? {
        get { UserDefaults.standard.value(forKey: .selectedPropertyIDsByUserKey) as? [String: String] }
        set { UserDefaults.standard.set(newValue, forKey: .selectedPropertyIDsByUserKey) }
    }
    
    func selectedProperty(forUser user: User) -> Property? {
        guard
            let propertyIDsByUserID = dictionary(forKey: .selectedPropertyIDsByUserKey),
            let propertyID = propertyIDsByUserID[user.id] as? String
            else { return nil }
        return user.properties?.first(where: { $0.id == propertyID })
    }

    func propertySelection(forUser user: User) -> PropertySelection {
        PropertySelection(selectedProperty(forUser: user))
    }

    func setSelectedProperty(_ property: Property?, forUser user: User) {
        var propertyIDsByUserID = dictionary(forKey: .selectedPropertyIDsByUserKey) ?? [:]

        if let property = property {
            propertyIDsByUserID[user.id] = property.id
            set(propertyIDsByUserID, forKey: .selectedPropertyIDsByUserKey)
        } else {
            removeObject(forKey: .selectedPropertyIDsByUserKey)
        }
        UserDefaults.propertySelectionByUserID.send([user.id: PropertySelection(property)])
    }
}

extension String {
    static let selectedPropertyIDsByUserKey = "selectedPropertyIDsByUser"
}
