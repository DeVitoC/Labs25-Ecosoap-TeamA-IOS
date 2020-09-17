//
//  MockUserDataProvider.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import KeychainAccess


/// Provides mock data to the UserController.
class MockUserDataProvider: UserDataProvider {
    enum Status {
        case loggedIn
        case loggedOut
    }

    /// If `true`, all `ResultHandler` completions will contain an error. If `false`, valid data will be returned.
    var shouldFail: Bool
    /// How long asynchronous method calls will wait to call the `completion` handler.
    var waitTime: Double
    /// If `true`, any bearer token returned from Okta and saved in the keychain will not be removed when logging out. If `false`, logging out will remove any token in the keychain.
    var testing: Bool

    /// The user that will be provided on successful login.
    var user = User.placeholder()
    /// Whether the mock provider is "logged in" or "out"
    var status = Status.loggedOut

    /// Initialize a new mock provider for user data.
    /// - Parameters:
    ///   - shouldFail: If `true`, all `ResultHandler` completions will contain an error. If `false`, valid data will be returned. Defaults to `false`.
    ///   - testing: If `true`, any bearer token returned from Okta and saved in the keychain will not be removed when logging out. If `false`, logging out will remove any token in the keychain. Defaults to `false`.
    ///   - waitTime: How long asynchronous method calls will wait to call the `completion` handler. Defaults to `0.2`.
    init(shouldFail: Bool = false, testing: Bool = false, waitTime: Double = 0.2) {
        self.shouldFail = shouldFail
        self.waitTime = waitTime
        self.testing = testing
    }

    func logIn(_ completion: @escaping ResultHandler<User>) {
        guard !shouldFail else {
            return completion(.mockFailure())
        }
        dispatch {
            if self.shouldFail {
                completion(.mockFailure())
            } else {
                self.status = .loggedIn
                completion(.success(.placeholder()))
            }
        }
    }

    func updateUserProfile(
        _ input: EditableProfileInfo,
        completion: @escaping ResultHandler<User>
    ) {
        dispatch { [weak self] in
            guard let self = self, !self.shouldFail
                else { return completion(.mockFailure()) }
            let newUser = User(
                id: input.id,
                firstName: input.firstName,
                middleName: input.middleName,
                lastName: input.lastName,
                title: self.user.title,
                company: self.user.company,
                email: input.email,
                phone: input.phone,
                skype: input.skype,
                properties: self.user.properties)

            self.user = newUser
            completion(.success(newUser))
        }
    }

    func updateProperty(
        with info: EditablePropertyInfo,
        completion: @escaping ResultHandler<Property>
    ) {
        dispatch { [weak self] in
            guard
                let self = self,
                !self.shouldFail,
                let oldProperty = self.user.properties?.first(where: { $0.id == info.id })
                else { return completion(.mockFailure()) }
            completion(.success(oldProperty.modifiedFromEditableInfo(info)))
        }
    }

    func logOut() {
        if testing {
            NSLog("Removing token (but not really)")
        } else {
            Keychain.Okta.removeToken()
        }
        self.status = .loggedOut
    }

    private func dispatch(_ work: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + waitTime, execute: work)
    }
}

// MARK: - Mock Models

extension User {
    /// Returns a mock user for testing purposes. Not for live use in production.
    static func placeholder() -> User {
        User(
            id: "0010",
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

extension Address {
    /// A mock property address for testing purposes. Not for live use in production.
    static let blepAddress = Address(
        address1: "999 Main St",
        address2: "Unit 8",
        address3: nil,
        city: "Bleptown",
        state: "MD",
        postalCode: "11111",
        country: "USA",
        formattedAddress: nil)
}

extension Property {
    /// A mock property for testing purposes. Not for live use in production.
    static let bobblyInn = Property(
        id: "3498",
        name: "Bobbly Inn",
        propertyType: .hotel,
        rooms: 20,
        services: HospitalityService.allCases,
        collectionType: .generatedLabel,
        logo: nil,
        phone: "555-124-3333",
        billingAddress: Address(
            address1: "PO Box 728",
            address2: nil,
            address3: nil,
            city: "Frankfurt",
            state: "CA",
            postalCode: "67890",
            country: "USA",
            formattedAddress: nil),
        shippingAddress: Address(
            address1: "123 Bobbly Road",
            address2: nil,
            address3: nil,
            city: "Frankfurt",
            state: "CA",
            postalCode: "67890",
            country: "USA",
            formattedAddress: nil),
        shippingNote: "Blep",
        notes: "bloop")
    /// A mock property for testing purposes. Not for live use in production.
    static let blepBnB = Property(
        id: "9377",
        name: "Blep Bed & Breakfast",
        propertyType: .bedAndBreakfast,
        rooms: 5,
        services: [.bottles, .soap],
        collectionType: .local,
        logo: nil,
        phone: "555-124-3333",
        billingAddress: .blepAddress,
        shippingAddress: .blepAddress,
        shippingNote: "Blep",
        notes: "bloop")
}

extension Array where Element == Property {
    /// Returns an array with two mock properties. Not for use in production.
    static func placeholders() -> [Property] { [.bobblyInn, .blepBnB] }
}

private extension Property {
    func modifiedFromEditableInfo(_ info: EditablePropertyInfo) -> Property {
        Property(
            id: info.id ?? id,
            name: info.name,
            propertyType: info.propertyType,
            rooms: rooms,
            services: services,
            collectionType: collectionType,
            logo: logo,
            phone: info.phone,
            billingAddress: billingAddress?.modifiedFromEditableInfo(info.billingAddress),
            shippingAddress: shippingAddress?.modifiedFromEditableInfo(info.shippingAddress),
            shippingNote: shippingNote,
            notes: notes)
    }
}

private extension Address {
    func modifiedFromEditableInfo(_ info: EditableAddressInfo) -> Address {
        Address(
            address1: info.address1,
            address2: info.address2,
            address3: info.address3,
            city: info.city,
            state: info.state,
            postalCode: info.postalCode,
            country: info.country,
            formattedAddress: self.formattedAddress)
    }
}
