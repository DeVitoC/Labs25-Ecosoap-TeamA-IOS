//
//  UserController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine


protocol UserDataProvider {
    func logIn(_ completion: @escaping NetworkCompletion<User>)
}


class UserController {
    private(set) var user: User?

    var dataLoader: UserDataProvider

    init(dataLoader: UserDataProvider) {
        self.dataLoader = dataLoader
    }

    func logIn() -> Future<User, Error> {
        Future { [weak self] promise in
            self?.dataLoader.logIn { result in
                if case .success(let user) = result {
                    self?.user = user
                }
                promise(result)
            }
        }
    }
}
