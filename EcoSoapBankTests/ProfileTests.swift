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
import KeychainAccess


class ProfileTests: XCTestCase {
    var strongDelegate: MockProfileDelegate!
    var user: User!
    var dataProvider: MockUserDataProvider!
    var userController: UserController!
    var coordinator: ProfileCoordinator!

    var badUser: User!

    var mainVM: MainProfileViewModel { coordinator.profileVM }

    override func setUp() {
        super.setUp()

        self.strongDelegate = MockProfileDelegate()
        self.user = .placeholder()
        self.dataProvider = MockUserDataProvider()
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

    func testLogOut() throws {
        let exp = expectation(description: "logging in")
        userController.logInWithBearer { _ in
            exp.fulfill()
        }
        wait(for: exp)

        XCTAssertEqual(dataProvider.status, .loggedIn)
        mainVM.logOut()
        XCTAssertNil(userController.user)
        XCTAssertEqual(strongDelegate.status, .loggedOut)
        XCTAssertEqual(dataProvider.status, .loggedOut)
        XCTAssertNil(userController.user)
    }
}

// MARK: - Delegate

class MockProfileDelegate {
    enum Status: Equatable {
        case started
        case loggedOut
    }

    var status: Status = .started
}

extension MockProfileDelegate: ProfileDelegate {
    func logOut() {
        status = .loggedOut
    }
}
