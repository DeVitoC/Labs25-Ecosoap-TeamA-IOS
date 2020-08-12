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
                \(QueryObjects.impactStats)
            }
        }
    }
    """

    static let userById = """
    query UserByIdInput($input: ID!) {
        userById(input:$input) {
            user {
                \(QueryObjects.user)
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
                    \(QueryObjects.address)
                }
                email
                phone
                coordinates {
                    \(QueryObjects.coordinates)
                }
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

    static let propertiesByUserId = """
    query PropertiesByUserIdInput($input: ID!) {
        propertiesByUserId(input:$input) {
            properties {
                \(QueryObjects.property)
            }
        }
    }
    """


}
