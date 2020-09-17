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

    var viewModel: ProfileViewModel { coordinator.profileVM }
    var currentProfileInfo: EditableProfileInfo {
        EditableProfileInfo(user: viewModel.user)
    }
    var newProfileInfo: EditableProfileInfo {
        configure(EditableProfileInfo(user: user)) {
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

        XCTAssertGreaterThanOrEqual(user.properties?.count ?? 0, 2)
    }

    // MARK: - Tests

    func testMainProfileVMSetup() throws {
        XCTAssertEqual(viewModel.properties, user.properties)
        XCTAssert(viewModel.propertyOptions.contains(.all))
        let userProperties = try XCTUnwrap(user.properties)
        let userSelections = userProperties.map { PropertySelection.select($0) }
        XCTAssertEqual(viewModel.propertyOptions.dropFirst(), userSelections[...])
    }

    func testUserControllerUpdateProfile() {
        logIn()

        let exp = expectation(description: "profile changed")
        let oldUser = viewModel.user

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
        exp.expectedFulfillmentCount = 2
        let oldUser = viewModel.user
        let oldInfo = currentProfileInfo
        var newUser: User?

        XCTAssertFalse(viewModel.loading)

        viewModel.$user
            .dropFirst()
            .sink { user in
                newUser = user
                exp.fulfill()
        }.store(in: &bag)
        viewModel.commitProfileChanges(newProfileInfo) {
            exp.fulfill()
        }
        XCTAssertTrue(viewModel.loading)

        wait(for: exp)

        XCTAssertNotEqual(oldUser, newUser)
        XCTAssertEqual(currentProfileInfo, newProfileInfo)
        XCTAssertNotEqual(currentProfileInfo, oldInfo)
        XCTAssertNil(viewModel.error)
    }

    func testProfileChangesFail() {
        dataProvider.shouldFail = true

        let exp = expectation(description: "profile changed")
        let oldUser = viewModel.user
        let oldInfo = currentProfileInfo
        var caughtError: Error?

        XCTAssertFalse(viewModel.loading)

        viewModel.$error
            .compactMap { $0 }
            .sink { error in
                caughtError = error
                exp.fulfill()
        }.store(in: &bag)
        viewModel.commitProfileChanges(newProfileInfo) {
            // only runs with success
            XCTFail("Completion should not run")
        }
        XCTAssertTrue(viewModel.loading)

        wait(for: exp)

        XCTAssertNotNil(caughtError)
        XCTAssertNotEqual(currentProfileInfo, newProfileInfo)
        XCTAssertEqual(currentProfileInfo, oldInfo)
        XCTAssertEqual(viewModel.user, oldUser)
    }

    func testLogOut() {
        logIn()

        XCTAssertEqual(dataProvider.status, .loggedIn)
        viewModel.logOut()
        XCTAssertNil(userController.user)
        XCTAssertEqual(strongDelegate.status, .loggedOut)
        XCTAssertEqual(dataProvider.status, .loggedOut)
        XCTAssertNil(userController.user)
    }

    /// Ensure setting `useShippingAddressForBilling` does not change the address until commiting.
    func testEditPropertyUseShippingAddressForBilling() {
        logIn()
        
        var info = EditablePropertyInfo(user.properties?.first!)
        info.billingAddress = EditableAddressInfo()
        viewModel.useShippingAddressForBilling = true

        XCTAssertNotEqual(info.shippingAddress, info.billingAddress)

        let didSavePropertyChanges = expectation(description: "Saved property changes")
        viewModel.savePropertyChanges(info) {
            didSavePropertyChanges.fulfill()
        }

        let userWillChange = expectation(description: "User about to change")
        viewModel.$user
            .dropFirst()
            .sink { _ in userWillChange.fulfill() }
            .store(in: &bag)

        wait(for: [didSavePropertyChanges, userWillChange], timeout: 2)

        XCTAssertEqual(viewModel.user.properties?.first?.shippingAddress,
                       viewModel.user.properties?.first?.billingAddress)
    }

    func testCommitProfileChangesSuccess() {
        logIn()
        var info = EditablePropertyInfo(user.properties?.first)

        info.phone = "999-555-8765"
        let oldProperty = user.properties?.first
        var newProperty: Property?

        let callsDidComplete = expectation(description: "calls completed")
        callsDidComplete.expectedFulfillmentCount = 2

        viewModel.$error
            .compactMap { $0 }
            .sink(receiveValue: { XCTFail("Failed with error: \($0)") })
            .store(in: &bag)
        viewModel.$user
            .dropFirst()
            .sink(receiveValue: { newUser in
                XCTAssertNotEqual(newProperty, newUser.properties?.first)
                newProperty = newUser.properties?.first
                callsDidComplete.fulfill()
            }).store(in: &bag)

        viewModel.savePropertyChanges(info) {
            callsDidComplete.fulfill()
        }

        wait(for: callsDidComplete)

        XCTAssertNotEqual(oldProperty, newProperty)
        XCTAssertEqual(EditablePropertyInfo(newProperty), info)
    }

    func testPropertyUpdateFailed() {
        userController = UserController(
            dataLoader: MockUserDataProvider(
                shouldFail: true,
                testing: true,
                waitTime: 0.1))
        let propInfo = configure(EditablePropertyInfo(user.properties?.first)) {
            $0.name = "BLAHHHHHH"
        }

        // user controller failure
        let controllerCompletedPropertyUpdate = expectation(description: "Returned from closure")
        userController.updateProperty(with: propInfo) { result in
            if case .success = result {
                XCTFail("Should not be successful")
            }
            controllerCompletedPropertyUpdate.fulfill()
        }

        // view model failure
        let vm = ProfileViewModel(user: user,
                                  userController: userController,
                                  delegate: nil)
        let vmHasError = expectation(description: "View model has an error")

        vm.$error
            .compactMap { $0 }
            .sink { _ in
                vmHasError.fulfill()
            }.store(in: &bag)
        vm.savePropertyChanges(propInfo) {
            XCTFail("Call should not succeed")
        }

        wait(for: [
            controllerCompletedPropertyUpdate,
            vmHasError
        ], timeout: 5)
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
