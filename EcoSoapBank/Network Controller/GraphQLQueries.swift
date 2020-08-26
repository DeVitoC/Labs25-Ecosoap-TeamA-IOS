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


    /* works with variables as:
     {
        "input": {
            "propertyId": "4" or 4
        }
     }
     */
    static let impactStatsByPropertyId = """
    query ImpactStatsByPropertyIdInput($input:ImpactStatsByPropertyIdInput) {
        impactStatsByPropertyId(input:$input) {
            impactStats {
                \(QueryObjects.impactStats)
            }
        }
    }
    """

    /* works with variables as:
     {
        "input": {
            "userId": "4" or 4
        }
     }
     */
    static let userById = """
    query UserByIdInput($input:UserByIdInput) {
        userById(input:$input) {
            user {
                \(QueryObjects.user)
            }
        }
    }
    """

    /* works with variables as:
     {
        "input": {
            "propertyId": "4" or 4
        }
     }
     */
    static let hubByPropertyId = """
    query HubByPropertyIdInput($input:HubByPropertyIdInput) {
        hubByPropertyId(input:$input) {
            hub {
                id
                name
                address {
                    \(QueryObjects.address)
                }
                email
                phone
                properties {
                    \(QueryObjects.property)
                }
                workflow
                impact {
                    \(QueryObjects.impactStats)
                }
            }
        }
    }
    """

    /* works with variables as:
     {
        "input": {
            "userId": "4" or 4
        }
     }
     */
    static let propertiesByUserId = """
    query PropertiesByUserIdInput($input: PropertiesByUserIdInput) {
        propertiesByUserId(input:$input) {
            properties {
                \(QueryObjects.property)
            }
        }
    }
    """

    /* works with variables as:
    {
        "input": {
            "propertyId": "4" or 4
        }
    }
    */
    static let pickupsByPropertyId = """
    query PickupsByPropertyIdInput($input: PickupsByPropertyIdInput) {
        pickupsByPropertyId(input:$input) {
            pickups {
                \(QueryObjects.pickup)
            }
        }
    }
    """
}
