//
//  UserController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine
import OktaAuth
import KeychainAccess


protocol UserDataProvider {
    /// Logs the user in using the Bearer token from Okta.
    /// - Parameter completion: A closure that takes in a `Result<User, Error>`, called when login is completed.
    func logIn(_ completion: @escaping ResultHandler<User>)
    /// Send a request to update the current user's profile info.
    /// - Parameters:
    ///   - input: The updated profile information.
    ///   - completion: A closure that takes in a `Result<User, Error>`, called when the request is completed. Contains the updated `User` object if successful.
    func updateUserProfile(_ input: EditableProfileInfo,
                           completion: @escaping ResultHandler<User>)
    /// Send a request to update the property with the provided ID.
    /// - Parameters:
    ///   - info: The updated property information.
    ///   - completion: A closure that takes in a `Result<Property, Error>`, called when the request is completed. Contains the updated `Property` object if successful.
    func updateProperty(with info: EditablePropertyInfo,
                        completion: @escaping ResultHandler<Property>)
    /// Log the user out, allowing them to log in as a different user.
    func logOut()
}


class UserController: ObservableObject {
    /// The currently logged in user.
    ///
    /// Can be subscribed to with Combine via `$user`.
    @Published private(set) var user: User?

    private var dataLoader: UserDataProvider
    
    private var cancellables: Set<AnyCancellable> = []

    /// Create a new UserController using the provided `dataLoader`.
    ///
    /// - Parameter dataLoader: The object making network calls (or mock network calls) on behalf of the `UserController`.
    init(dataLoader: UserDataProvider) {
        self.dataLoader = dataLoader

        OktaAuth.success
            .mapError { _ in LoginError.loginFailed }
            .flatMap({
                Future { [weak self] promise in
                    self?.logInWithBearer { result in
                        promise(result)
                    }
                }
            }).handleError { OktaAuth.error.send($0) }
            .sink { _ in }
            .store(in: &cancellables)

    }
}

// MARK: - Public

extension UserController {
    var oktaLoginURL: URL? { OktaAuth.shared.identityAuthURL() }

    /// Logs the user in using the Bearer token from Okta.
    /// - Parameter completion: A closure that takes in a `Result<User, Error>`, called when login is completed.
    func logInWithBearer(completion: @escaping ResultHandler<User> = { _ in }) {
        self.dataLoader.logIn { [weak self] result in
            if let user = try? result.get() {
                self?.user = user
            }
            completion(result)
        }
    }

    /// Send a request to update the current user's profile info.
    /// - Parameters:
    ///   - input: The updated profile information.
    ///   - completion: A closure that takes in a `Result<User, Error>`, called when the request is completed. Contains the updated `User` object if successful.
    func updateUserProfile(_ input: EditableProfileInfo, completion: @escaping ResultHandler<User>) {
        dataLoader.updateUserProfile(input) { [weak self] result in
            if let newUser = try? result.get() {
                self?.user = newUser
            }
            completion(result)
        }
    }

    /// Send a request to update the property with the provided ID.
    /// - Parameters:
    ///   - info: The updated property information.
    ///   - completion: A closure that takes in a `Result<Property, Error>`, called when the request is completed. Contains the updated `Property` object if successful.
    func updateProperty(with info: EditablePropertyInfo, completion: @escaping ResultHandler<Property>) {
        dataLoader.updateProperty(with: info) { [weak self] result in
            defer { completion(result) }
            guard let newProperty = try? result.get() else { return }
            self?.user = self?.user?.updatingProperty(newProperty)
        }
    }

    /// Log the user out, allowing them to log in as a different user.
    ///
    /// Sets the controller's `user` to nil and logs out via the controller's `dataLoader`.
    func logOut() {
        user = nil
        dataLoader.logOut()
    }
}
