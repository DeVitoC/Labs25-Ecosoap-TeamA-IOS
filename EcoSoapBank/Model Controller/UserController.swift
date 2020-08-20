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


protocol UserDataProvider {
    func logIn(_ completion: @escaping NetworkCompletion<User>)
    func provideToken(_ token: String)
}


class UserController {
    private var dataLoader: UserDataProvider

    private var userSubject = CurrentValueSubject<User?, Error>(nil)

    private var cancellables: Set<AnyCancellable> = []

    init(dataLoader: UserDataProvider) {
        self.dataLoader = dataLoader

        NotificationCenter.default
            .publisher(for: .oktaAuthenticationSuccessful)
            .sink(receiveValue: loginDidComplete(_:))
            .store(in: &cancellables)
    }
}


extension UserController {
    var oktaLoginURL: URL? { oktaAuth.identityAuthURL() }
    var user: User? { userSubject.value }
    var userPublisher: AnyPublisher<User?, Error> {
        userSubject.eraseToAnyPublisher()
    }

    func logInWithBearer() -> Future<User, Error> {
        Future { promise in
            self.dataLoader.logIn { [weak self] result in
                if case .success(let user) = result {
                    self?.userSubject.send(user)
                }
                promise(result)
            }
        }
    }
}


extension UserController {
    private var oktaAuth: OktaAuth { OktaAuth.shared }
    
    private func loginDidComplete(_ notification: Notification) {
        guard let token = try? oktaAuth.credentialsIfAvailable().accessToken else {
            preconditionFailure("Auth missing after successful login")
            // TODO: handle missing token after login
        }
        dataLoader.provideToken(token)
        dataLoader.logIn { [weak userSubject] result in
            switch result {
            case .success(let user):
                userSubject?.send(user)
            case .failure(let error):
                userSubject?.send(completion: .failure(error))
            }
        }
    }
}
