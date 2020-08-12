//
//  GraphQLQueries.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum GraphQLQueries {
    // MARK: - Queries


    static let impactStatsByPropery = """
    query ImpactStatsByPropertyIdInput($input: ID!) {
        impactStatsByPropertyId(input:$input) {
            impactStats {
                \(impactStats)
            }
        }
    }
    """

    static let userById = """
    query UserByIdInput($input: ID!) {
        userById(input:$input) {
            user {
                \(user)
            }
        }
    }
    """

    static let hubByPropertyId = """
    query HubByPropertyIdInput($input: ID!) {
        hubByPropertyId(input:$id) {
            hub {
                id
                name
                address {
                    \(address)
                }
                email
                phone
                coordinates {
                    \(coordinates)
                }
                properties {
                    \(property)
                }
                workflow
                impact {
                    \(impactStats)
                }
            }
        }
    }
    """

    static let propertiesByUserId = """
    query PropertiesByUserIdInput($input: ID!) {
        propertiesByUserId(input:$input) {
            properties {
                \(property)
            }
        }
    }
    """

    // MARK: - Query Objects
    static let impactStats = """
    soapRecycled
    linensRecycled
    bottlesRecycled
    paperRecycled
    peopleServed
    womenEmployed
    """

    static let user = """
    id
    firstName
    middleName
    lastName
    title
    company
    email
    phone
    skype
    address {
        \(address)
    }
    signupTime
    properties {
        \(property)
    }
    """

    static let address = """
    address1
    address2
    address3
    city
    state
    postalCode
    country
    formattedAddress
    """

    // Property and Contract have an unresolved circular reference - required field
    // Property and Pickup have an unresolved circular reference - required field
    /* temporarily removed Contract from Property. if needed put this back in after users/pickups:
     contract {
     \(contract)
     }
     */
    /* temporarily removed Pickup from Property. if needed put this back in after users:
     pickups {
     \(pickup)
     }
     */
    static let property = """
    id
    name
    propertyType
    rooms
    services
    collectionType
    logo
    phone
    billingAddress {
        \(address)
    }
    shippingAddress {
        \(address)
    }
    coordinates {
        \(coordinates)
    }
    shippingNote
    notes
    hub {
        \(hub)
    }
    impact {
        \(impactStats)
    }
    users {
        \(userWithOnlyRequiredFields)
    }
    """

    static let coordinates = """
    latitude
    longitude
    """

    static let hub = """
    id
    name
    address {
        \(address)
    }
    email
    phone
    coordinates {
        \(coordinates)
    }
    workflow
    impact {
        \(impactStats)
    }
    """

    static let userWithOnlyRequiredFields = """
    id
    firstName
    lastName
    email
    phone
    """
}
