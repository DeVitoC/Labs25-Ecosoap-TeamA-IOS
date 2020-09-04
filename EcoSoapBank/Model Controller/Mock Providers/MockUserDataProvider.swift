//
//  MockUserDataProvider.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import KeychainAccess


class MockUserDataProvider: UserDataProvider {
    enum Status {
        case loggedIn
        case loggedOut
    }

    var shouldFail: Bool
    var waitTime: Double

    var user = User.placeholder()
    var status = Status.loggedOut

    var dataLoader: DataLoader = MockDataLoader(data: nil, error: nil)

    init(shouldFail: Bool = false, waitTime: Double = 0.2) {
        self.shouldFail = shouldFail
        self.waitTime = waitTime
    }

    func logIn(_ completion: @escaping ResultHandler<User>) {
        guard !shouldFail else {
            return completion(.mockFailure())
        }

        do {
            let token = try dataLoader.getToken()
            print(token) // TODO: remove from production

            dispatch {
                if self.shouldFail {
                    completion(.mockFailure())
                } else {
                    self.status = .loggedIn
                    completion(.success(.placeholder()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func updateUserProfile(
        _ input: EditableProfileInfo,
        completion: @escaping ResultHandler<User>
    ) {
        let newUser = User(
            id: input.id,
            firstName: input.firstName,
            middleName: input.middleName,
            lastName: input.lastName,
            title: user.title,
            company: user.company,
            email: input.email,
            phone: input.phone,
            skype: input.skype,
            properties: user.properties)

        dispatch {
            if self.shouldFail == true {
                completion(.mockFailure())
            } else {
                self.user = newUser
                completion(.success(newUser))
            }
        }
    }

    func logOut() {
        NSLog("Removing token (but not really)")
        self.status = .loggedOut
    }

    private func dispatch(_ work: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + waitTime, execute: work)
    }
}

// MARK: - Mock Models

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
