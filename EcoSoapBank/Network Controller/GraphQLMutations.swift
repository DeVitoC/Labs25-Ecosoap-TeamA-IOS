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

    /* works with variables as:
     {
        "input": {
            "email": "email@here.com",
            "password": "passwordHere"
        }
     }
     */
    static let login = """
    mutation LogIn($input: LogInInput) {
        logIn(input: $input) {
            user {
                \(QueryObjects.user)
            }
        }
    }
    """
    
    static let updateUserProfile = """
    mutation UpdateUserProfile($input: UpdateUserProfileInput) {
        updateUserProfile(input: $input) {
            user {
                \(QueryObjects.user)
            }
        }
    }
    """
    
    static let updateProperty = """
    mutation UpdateProperty($input: UpdatePropertyInput) {
        updateProperty(input: $input) {
            property {
                \(QueryObjects.property)
            }
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
    static let schedulePickup = """
    mutation SchedulePickup($input: SchedulePickupInput) {
        schedulePickup(input: $input) {
            pickup {
                \(QueryObjects.pickup)
            }
            label
        }
    }
    """

    /* works with variables as:
    {
        "input": {
            "pickupId": "4" or 4
            "confirmationCode: "CodeGoesHere"
        }
    }
     */
    static let cancelPickup = """
    mutation CancelPickup($input: CancelPickupInput) {
        cancelPickup(input: $input) {
            pickup {
                \(QueryObjects.pickup)
            }
        }
    }
    """
}
