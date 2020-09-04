//
//  MockLoginProvider.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import KeychainAccess


class MockLoginProvider: UserDataProvider {
    var shouldFail: Bool
    var waitTime: Double

    init(shouldFail: Bool = false, waitTime: Double = 0.2) {
        self.shouldFail = shouldFail
        self.waitTime = waitTime
    }

    func logIn(_ completion: @escaping ResultHandler<User>) {
        guard let token = Keychain.Okta.getToken() else {
            return completion(.mockFailure())
        }
        print(token)

        DispatchQueue.global().asyncAfter(deadline: .now() + waitTime) {
            if self.shouldFail {
                completion(.mockFailure())
            } else {
                completion(.success(.placeholder()))
            }
        }
    }

    func logOut() {
        NSLog("Removing token (but not really)")
    }
}


extension User {
    static func placeholder() -> User {
        User(
            id: String(Int.random(in: Int.min ... Int.max)),
            firstName: "Bibbly",
            middleName: "Chrumbus",
            lastName: "Bobbly",
            title: nil,
            company: "Bobbly Inc.",
            email: "Bibbly@Bobbly.zone",
            phone: "555-123-4444",
            skype: nil,
            properties: .placeholders())
    }
}


extension Array where Element == Property {
    static func placeholders() -> [Property] {
        [
            Property(
                id: "3498",
                name: "Bobbly Inn",
                propertyType: .hotel,
                rooms: 20,
                services: HospitalityService.allCases,
                collectionType: .random(),
                logo: nil,
                phone: "555-124-3333",
                billingAddress: nil,
                shippingAddress: nil,
                shippingNote: "Blep",
                notes: "bloop"),
            Property(
                id: "9377",
                name: "Blep Bed & Breakfast",
                propertyType: .bedAndBreakfast,
                rooms: 5,
                services: [.bottles, .soap],
                collectionType: .random(),
                logo: nil,
                phone: "555-124-3333",
                billingAddress: nil,
                shippingAddress: nil,
                shippingNote: "Blep",
                notes: "bloop"),

        ]
    }
}
