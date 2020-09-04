//
//  ProfileTests.swift
//  EcoSoapBankTests
//
//  Created by Jon Bash on 2020-09-04.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import EcoSoapBank

class ProfileTests: XCTestCase {
    var user: User!
    var dataProvider: UserDataProvider!
    var userController: UserController!
    var coordinator: ProfileCoordinator!

    var badUser: User!

    var mainVM: MainProfileViewModel { coordinator.profileVM }

    override func setUp() {
        super.setUp()
        self.user = .placeholder()
        self.dataProvider = MockLoginProvider()
        self.userController = UserController(dataLoader: dataProvider)
        self.coordinator = ProfileCoordinator(user: user,
                                              userController: userController)

        self.badUser = User(
            id: "",
            firstName: "",
            middleName: nil,
            lastName: "",
            title: nil,
            company: nil,
            email: "",
            phone: nil,
            skype: nil,
            properties: nil)
    }
}
