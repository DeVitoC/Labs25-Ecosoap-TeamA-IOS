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
    mutation LogInInput($input: LogInInput) {
        logIn(input:$input) {
            user {
                id
                firstName
                lastName
                email
                password
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
    mutation SchedulePickupInput($input: SchedulePickupInput) {
        schedulePickup(input:$input) {
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
    mutation CancelPickupInput($input: CancelPickupInput) {
        cancelPickup(input:$input) {
            pickup {
                \(QueryObjects.pickup)
            }
        }
    }
    """

    /* takes no variables - put nil value*/
    static let seedDatabase = """
    mutation {
        seedDatabase {
            \(QueryObjects.successPayload)
        }
    }
    """

    /* works with variables as:
    {
        "input": "DELETE"
    }
    */
    static let wipeDatabase = """
    mutation WipeDatabaseInput($input: String) {
        wipeDatabase(input:$input) {
            \(QueryObjects.successPayload)
        }
    }
    """
}
