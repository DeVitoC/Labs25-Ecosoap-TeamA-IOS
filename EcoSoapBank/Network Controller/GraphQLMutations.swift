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
            "collectionType":"enum:Pickup.CollectionType",
            "status":"enum:Pickup.Status",
            "readyDate":"Date()",
            "PickupDate":"Date()"?,
            "propertyId":"ID",
            "cartons":["PickupCartonInput": {
                "product":"enum:HospitalityService"?,
                "weight":"Int"?
            }],
            "notes":"NotesGoHere"?
        }
     }
    */
}
