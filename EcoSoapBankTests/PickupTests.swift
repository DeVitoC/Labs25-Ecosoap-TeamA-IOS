//
//  PickupTests.swift
//  EcoSoapBankTests
//
//  Created by Jon Bash on 2020-08-11.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import EcoSoapBank


class PickupTests: XCTestCase {
    private var pickupCoordinator: PickupCoordinator!
    private var pickupController: PickupController!
    private var pickupProvider: MockPickupProvider!

    private var expectationsCount = 0

    private var bag = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        bag = []
        let user = User.placeholder()
        pickupProvider = MockPickupProvider()
        pickupController = PickupController(user: user, dataProvider: pickupProvider)
        pickupCoordinator = PickupCoordinator(user: user, dataProvider: pickupProvider)
    }

    // MARK: - Tests

    func testPickupControllerFetchAllSuccess() throws {
        let exp = newMockExpectation()
        pickupProvider.fetchAllPickups { result in
            switch result {
            case .failure(let error):
                XCTFail("Mock pickup provider should have succeeded but failed with error: \(error)")
            case .success(let pickups):
                XCTAssertGreaterThan(pickups.count, 0)
            }

            exp.fulfill()
        }
        wait(for: exp)
    }

    func testPickupControllerFetchAllFailure() {
        pickupProvider.shouldFail = true
        let failingController = PickupController(
            user: .placeholder(),
            dataProvider: pickupProvider)

        let exp = newMockExpectation()

        pickupProvider.fetchAllPickups { result in
            if case .success = result {
                XCTFail("Mock pickup provider should have failed but succeeded")
            }
            exp.fulfill()
        }
        wait(for: exp)

        XCTAssert(failingController.pickups.isEmpty)
    }

    func testPickupCoordinatorStart() {
        pickupCoordinator.start()
    }

    func testSchedulePickup() {
        let exp1 = XCTestExpectation(description: "Waiting for mock data 1")

        let input = Pickup.ScheduleInput.random()

        pickupController.schedulePickup(for: input)
            .sink(
                receiveCompletion: handleCompletion(_:),
                receiveValue: { _ in
                    exp1.fulfill()
            }).store(in: &bag)

        wait(for: exp1)
    }

    func testCoordinatorScheduleVMIsResetOnSchedule() throws {
        let exp = newMockExpectation()
        let firstVM = pickupCoordinator.schedulePickupVM

        let input = Pickup.ScheduleInput.random()

        pickupCoordinator.schedulePickup(for: input) { result in
            let pickupResult = try? XCTUnwrap(try? result.get())

            XCTAssertEqual(pickupResult?.pickup?.base, input.base)
            XCTAssert(self.pickupCoordinator.schedulePickupVM !== firstVM)

            exp.fulfill()
        }

        wait(for: exp)
    }

    func testCoordinatorScheduleVMIsNotResetOnCancel() {
        let firstVM = pickupCoordinator.schedulePickupVM

        pickupCoordinator.scheduleNewPickup()
        pickupCoordinator.cancelNewPickup()

        XCTAssert(firstVM === pickupCoordinator.schedulePickupVM)
    }

    func testUserPropertiesTransferredProperly() {
        XCTAssertEqual(pickupCoordinator.schedulePickupVM.properties,
                       pickupController.user.properties)
    }
}

// MARK: - Helpers

extension PickupTests {
    private func newMockExpectation() -> XCTestExpectation {
        expectationsCount += 1
        return XCTestExpectation(
            description: "Waiting for mock data \(expectationsCount)")
    }

    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        if case .failure(let error) = completion {
            XCTFail("completed with error: \(error)")
        }
    }
}

protocol HostingController {}

extension UIHostingController: HostingController {}

extension XCTestCase {
    func wait(for expectation: XCTestExpectation, timeout: TimeInterval = 5) {
        wait(for: [expectation], timeout: timeout)
    }
}


protocol KeyPathListable {
    var allKeyPaths: [PartialKeyPath<Self>] { get }
}

extension KeyPathListable {
    var allKeyPaths: [PartialKeyPath<Self>] {
        let mirror = Mirror(reflecting: self)

        return mirror.children
            .reduce(into: [PartialKeyPath<Self>]()) { keyPaths, labelValuePair in
                guard let key = labelValuePair.label else { return }
                keyPaths.append(\Self.[checkedMirrorDescendent: key] as PartialKeyPath)
        }
    }

    private subscript(checkedMirrorDescendent key: String) -> Any {
        Mirror(reflecting: self).descendant(key)!
    }
}

extension Property: KeyPathListable {}
