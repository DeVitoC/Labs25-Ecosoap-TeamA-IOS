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
            self.mockDataReturned()

            switch result {
            case .failure(let error):
                XCTFail("Mock pickup provider should have succeeded but failed with error: \(error)")
            case .success(let pickups):
                XCTAssertGreaterThan(pickups.count, 0)
            }
        }
        waitForMockData()

        XCTAssertGreaterThan(pickupController.pickups.count, 0)
        XCTAssertNil(pickupController.error)
    }

    func testPickupControllerFailure() {
        pickupProvider.shouldFail = true
        let failingController = PickupController(dataProvider: pickupProvider)

        pickupProvider.fetchAllPickups { result in
            self.mockDataReturned()

            if case .success = result {
                XCTFail("Mock pickup provider should have failed but succeeded")
            }
        }
        waitForMockData()

        XCTAssert(failingController.pickups.isEmpty)
        XCTAssertNotNil(failingController.error)
    }

    func testPickupCoordinator() {
        pickupCoordinator.start()

        XCTAssertNotNil(pickupCoordinator.rootVC as? HostingController)
    }
}

// MARK: - Helpers

extension PickupTests {
    private func waitForMockData() {
        waiter.wait(for: [mockDataExpectation], timeout: 5)
    }

    private func mockDataReturned() {
        mockDataExpectation.fulfill()
    }
}

protocol HostingController {}

extension UIHostingController: HostingController {}
