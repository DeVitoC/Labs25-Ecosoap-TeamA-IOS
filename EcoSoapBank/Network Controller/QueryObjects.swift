//
//  QueryObjects.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum QueryObjects {
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
    password
    phone
    skype
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

    // Property and Contract have a possible circular reference
    // Property and Pickup have a possible circular reference
    // Permanently removed contract from Property.
    // Permanently removed pickups from Property.
    static let property = """
    id
    name
    propertyType
    rooms
    services
    collectionType
    logo
    phone
    shippingNote
    notes
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
    password
    phone
    """

    static let pickup = """
    id
    confirmationCode
    collectionType
    status
    readyDate
    pickupDate
    property {
        \(property)
    }
    cartons {
        \(carton)
    }
    notes
    """

    static let carton = """
    id
    product
    weight
    """
}
