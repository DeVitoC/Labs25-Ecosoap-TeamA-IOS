//
//  PickupTests.swift
//  EcoSoapBankTests
//
//  Created by Jon Bash on 2020-08-11.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
import SwiftUI
@testable import EcoSoapBank


class PickupTests: XCTestCase {
    private var pickupCoordinator: PickupCoordinator!
    private var pickupController: PickupController!
    private var pickupProvider: MockPickupProvider!
    private var mockDataExpectation: XCTestExpectation!
    private var waiter: XCTWaiter!

    override func setUp() {
        super.setUp()
        pickupProvider = MockPickupProvider()
        pickupController = PickupController(dataProvider: pickupProvider)
        pickupCoordinator = PickupCoordinator(pickupController: pickupController)
        mockDataExpectation = XCTestExpectation(description: "Waiting for mock data")
        waiter = XCTWaiter(delegate: self)
    }

    // MARK: - Tests

    func testPickupControllerSuccess() throws {
        pickupProvider.fetchAllPickups { result in
            mockDataExpectation.fulfill()

            switch result {
            case .failure(let error):
                XCTFail("Mock pickup provider should have succeeded but failed with error: \(error)")
            case .success(let pickups):
                XCTAssertGreaterThan(pickups.count, 0)
            }
        }
        waiter.wait(for: [mockDataExpectation], timeout: 5)

        XCTAssertGreaterThan(pickupController.pickups.count, 0)
        XCTAssertNil(pickupController.error)
    }

    func testPickupControllerFailure() {
        pickupProvider.shouldFail = true
        let failingController = PickupController(dataProvider: pickupProvider)

        pickupProvider.fetchAllPickups { result in
            mockDataExpectation.fulfill()

            if case .success = result {
                XCTFail("Mock pickup provider should have failed but succeeded")
            }
        }
        waiter.wait(for: [mockDataExpectation], timeout: 5)

        XCTAssert(failingController.pickups.isEmpty)
        XCTAssertNotNil(failingController.error)
    }

    func testPickupCoordinator() {
        pickupCoordinator.start()

        XCTAssertNotNil(pickupCoordinator.rootVC as? HostingController)
    }
}

// MARK: - Helpers

protocol HostingController {}

extension UIHostingController: HostingController {}
