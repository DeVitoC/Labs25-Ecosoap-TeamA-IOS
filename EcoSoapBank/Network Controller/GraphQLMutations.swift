//
//  GraphQLMutations.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum GraphQLMutations {
    // MARK: - Mutations
    static let login = """
    mutation LoginInput($input: LogInInput) {
        login(input:$input) {
            token
            user {
                id
                firstName
                lastName
                email
            }
        }
    }
    """
    /* works with variables as:
     {
        "input": {
            "email": "email@here.com",
            "password": "passwordHere"
        }
     }
     */

    static let schedulePickup = """
    mutation SchedulePickupInput($input: SchedulePickupInput) {
        schedulePickup(input:$input) {
            \(QueryObjects.pickup)
            label
        }
    }
    """
    /* works with variables as:
    {
        "input": {
            "collectionType":"enum:CollectionType",
            "status":"enum:PickupStatus",
            "readyDate":"Date()",
            "PickupDate":"Date()"?,
            "propertyId":"ID",
            "cartons":["PickupCartonInput": {"product":"enum:HospitalityService","weight":"Int"}],
            "notes":"NotesGoHere"
        }
     }
    */
}

// MARK: - Enums for input variables
enum CollectionType: String {
    case courierConsolidated = "COURIER_CONSOLIDATED"
    case courierDirect = "COURIER_DIRECT"
    case generatedLabel = "GENERATED_LABEL"
    case local = "LOCAL"
    case other = "OTHER"
}

enum PickupStatus: String {
    case submitted = "SUBMITTED"
    case outForPickup = "OUT_FOR_PICKUP"
    case complete = "COMPLETE"
    case cancelled = "CANCELLED"
}
