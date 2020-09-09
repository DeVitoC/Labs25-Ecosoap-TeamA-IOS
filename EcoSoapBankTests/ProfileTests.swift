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
import Combine


class ProfileTests: XCTestCase {
    var strongDelegate: MockProfileDelegate!
    var user: User!
    var dataProvider: MockUserDataProvider!
    var userController: UserController!
    var coordinator: ProfileCoordinator!

    var badUser: User!

    var mainVM: MainProfileViewModel { coordinator.profileVM }
    var newProfileInfo: EditableProfileInfo {
        configure(mainVM.editableInfo) {
            $0.email = "new@email.net"
            $0.middleName = "Lasagna"
            $0.skype = "new-skype-handle"
        }
    }

    var bag = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        self.strongDelegate = MockProfileDelegate()
        self.user = .placeholder()
        self.dataProvider = MockUserDataProvider(testing: true, waitTime: 0.1)
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
        self.bag = []
    }

    // MARK: - Tests

    func testMainProfileVMSetup() throws {
        XCTAssertEqual(mainVM.properties, user.properties)
        XCTAssert(mainVM.propertyOptions.contains(.all))
        let userProperties = try XCTUnwrap(user.properties)
        let userSelections = userProperties.map { PropertySelection.select($0) }
        XCTAssertEqual(mainVM.propertyOptions.dropFirst(), userSelections[...])
    }

    func testUserControllerUpdateProfile() {
        logIn()

        let exp = expectation(description: "profile changed")
        let oldUser = mainVM.user

        let info = newProfileInfo
        var newUser: User?
        userController.updateUserProfile(info) { result in
            guard let user = try? result.get() else {
                return XCTFail("Update user failed with error: \(result.error!)")
            }
            newUser = user
            exp.fulfill()
        }

        wait(for: exp)
        XCTAssertNotEqual(newUser, oldUser)
    }

    func testProfileChanges() {
        logIn()

        let exp = expectation(description: "profile changed")
        let oldUser = mainVM.user
        let oldInfo = mainVM.editableInfo
        var newUser: User?

        XCTAssertFalse(mainVM.loading)

        mainVM.editableInfo = newProfileInfo
        mainVM.$user
            .dropFirst()
            .sink { user in
                newUser = user
                exp.fulfill()
        }.store(in: &bag)
        mainVM.commitProfileChanges()
        XCTAssertTrue(mainVM.loading)

        wait(for: exp)

        XCTAssertNotEqual(oldUser, newUser)
        XCTAssertEqual(mainVM.editableInfo, newProfileInfo)
        XCTAssertNotEqual(mainVM.editableInfo, oldInfo)
        XCTAssertNil(mainVM.error)
    }

    func testProfileChangesFail() {
        dataProvider.shouldFail = true

        let exp = expectation(description: "profile changed")
        let oldUser = mainVM.user
        let oldInfo = mainVM.editableInfo
        var caughtError: Error?

        XCTAssertFalse(mainVM.loading)

        mainVM.editableInfo = newProfileInfo
        mainVM.$error
            .compactMap { $0 }
            .sink { error in
                caughtError = error
                exp.fulfill()
        }.store(in: &bag)
        mainVM.commitProfileChanges()
        XCTAssertTrue(mainVM.loading)

        wait(for: exp)

        XCTAssertNotNil(caughtError)
        XCTAssertEqual(mainVM.editableInfo, newProfileInfo)
        XCTAssertNotEqual(mainVM.editableInfo, oldInfo)
        XCTAssertEqual(mainVM.user, oldUser)
    }

    func testLogOut() throws {
        logIn()

        XCTAssertEqual(dataProvider.status, .loggedIn)
        mainVM.logOut()
        XCTAssertNil(userController.user)
        XCTAssertEqual(strongDelegate.status, .loggedOut)
        XCTAssertEqual(dataProvider.status, .loggedOut)
        XCTAssertNil(userController.user)
    }
}

// MARK: - Helpers

extension ProfileTests {
    func logIn() {
        let exp = expectation(description: "logging in")
        userController.logInWithBearer { _ in
            exp.fulfill()
        }
        wait(for: exp)
    }
}


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
