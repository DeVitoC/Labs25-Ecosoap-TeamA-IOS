//
//  ProfileTests.swift
//  EcoSoapBankTests
//
//  Created by Jon Bash on 2020-09-04.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
// swiftlint:disable weak_delegate
// ^^ Disabled because a strong reference is required to keep a reference to it

import XCTest
@testable import EcoSoapBank

class ProfileTests: XCTestCase {
    var strongDelegate: ProfileDelegate!
    var user: User!
    var dataProvider: UserDataProvider!
    var userController: UserController!
    var coordinator: ProfileCoordinator!

    var badUser: User!

    var mainVM: MainProfileViewModel { coordinator.profileVM }

    override func setUp() {
        super.setUp()
        self.strongDelegate = MockProfileDelegate()
        self.user = .placeholder()
        self.dataProvider = MockLoginProvider()
        self.userController = UserController(dataLoader: dataProvider)
        self.coordinator = ProfileCoordinator(user: user,
                                              userController: userController,
                                              delegate: strongDelegate)

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

    func testMainProfileVMSetup() throws {
        XCTAssertEqual(mainVM.properties, user.properties)
        XCTAssert(mainVM.propertyOptions.contains(.all))
        let userProperties = try XCTUnwrap(user.properties)
        let userSelections = userProperties.map { PropertySelection.select($0) }
        XCTAssertEqual(mainVM.propertyOptions.dropFirst(), userSelections[...])
    }
}


class MockProfileDelegate: ProfileDelegate {
    enum Status {
        case started
        case loggedOut
    }

    var status: Status = .started

    func logOut() {

    }
}
