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

    static let impactStatsByPropery = """
    query ImpactStatsByPropertyIdInput($input: ID!) {
        impactStatsByPropertyId(input:$input) {
            impactStats {
                \(impactStats)
            }
        }
    }
    """

    static let nextPaymentByPropertyId = """
    query NextPaymentByPropertyIdInput($input: ID!) {
        nextPaymentByPropertyId(input:$input) {
            payment {
                \(payment)
            }
        }
    }
    """

    static let paymentsByPropertyid = """
    query PaymentsByPropertyIdInput($input: ID!) {
        paymentsByPropertyId(input:$input) {
            payments {
                \(payment)
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

    static let propertiesByUserId = """
    query PropertiesByUserIdInput($input: ID!) {
        propertiesByUserId(input:$input) {
            properties {
                \(property)
            }
        }
    }
    """

    static let propertyById = """
    query PropertyByIdInput($input: ID!) {
        propertyById(input:$input) {
            property {
                \(property)
            }
        }
    }
    """


    // MARK: - Query Objects
    // Pickup and Property have an unresolved circular reference
    /* temporarily removed property from pickup. if needed put this back in after pickupDate:
        property {
            \(property)
        }
     */
    static let pickup = """
    id
    confirmationCode
    collectionType
    status
    readyDate
    pickupDate
    cartons {
        \(carton)
    }
    notes
    """

    // Contract and property have an unresolved circular reference
    // Contract and NegotiatedContract have an unresolved circular reference
    // Contract and Payment have an unresolved circular reference
    /* temporarily removed property from Contract. if needed put this back in after paymentEndDate:
        properties {
            \(property)
        }
     */
    /* temporarily removed NegotiatedContract from Contract. if needed put this back in after pickupDate/properties:
        negotiatedRateContract {
            \(negotiatedContract)
        }
     */
    /* temporarily removed Payments from Contract. if needed put this back in after automatedBilling:
        payments {
            \(payment)
        }
     */
    static let contract = """
    id
    startDate
    endDate
    paymentStartDate
    paymentEndDate
    paymentFrequency
    price
    discount
    billingMethod
    automatedBilling
    amountPaid
    """

    // Property and Contract have an unresolved circular reference
    // Property and Pickup have an unresolved circular reference
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
        \(userWithoutProperties)
    }
    """

    // NegotiatedContract and Contract have an unresolved circular reference
    static let negotiatedContract = """
    id
    startDate
    endDate
    paymentStartDate
    paymentEndDate
    contracts {
        \(contract)
    }
    paymentFrequency
    price
    discount
    billingMethod
    automatedBilling
    payments {
        \(payment)
    }
    amountPaid
    """

    static let payment = """
    id
    invoiceCode
    invoice
    amountPaid
    amountDue
    date
    invoicePeriodStartDate
    invoicePeriodEndDate
    dueDate
    paymentMethod
    hospitalityContract {
        \(contract)
    }
    """

    static let carton = """
    id
    product
    weight
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

    static let userWithoutProperties = """
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

    """

    static let impactStats = """
    soapRecycled
    linensRecycled
    bottlesRecycled
    paperRecycled
    peopleServed
    womenEmployed
    """

    static let coordinates = """
    latitude
    longitude
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
}
