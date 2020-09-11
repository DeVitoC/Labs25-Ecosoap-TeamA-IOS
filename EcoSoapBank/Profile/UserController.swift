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
    func logIn(_ completion: @escaping ResultHandler<User>)
    func updateUserProfile(_ input: EditableProfileInfo, completion: @escaping ResultHandler<User>)
    func logOut()
}


class UserController: ObservableObject {
    @Published private(set) var user: User?

    private var dataLoader: UserDataProvider
    
    private var cancellables: Set<AnyCancellable> = []

    init(dataLoader: UserDataProvider) {
        self.dataLoader = dataLoader

        OktaAuth.success
            .sink { [weak self] in self?.logInWithBearer() }
            .store(in: &cancellables)
    }
}

// MARK: - Public

extension UserController {
    var oktaLoginURL: URL? { OktaAuth.shared.identityAuthURL() }

    func logInWithBearer(completion: @escaping ResultHandler<User> = { _ in }) {
        self.dataLoader.logIn { [weak self] result in
            if let user = try? result.get() {
                self?.user = user
            }
            completion(result)
        }
    }

    func updateUserProfile(_ input: EditableProfileInfo, completion: @escaping ResultHandler<User>) {
        dataLoader.updateUserProfile(input) { [weak self] result in
            if let newUser = try? result.get() {
                self?.user = newUser
            }
            completion(result)
        }
    }

    func logOut() {
        user = nil
        dataLoader.logOut()
    }
}
