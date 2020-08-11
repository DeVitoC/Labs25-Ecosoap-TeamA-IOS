//
//  PickupTests.swift
//  EcoSoapBankTests
//
//  Created by Jon Bash on 2020-08-11.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import EcoSoapBank


class PickupTests: XCTestCase {
    func testPickupControllerSuccess() throws {
        let pickupController = PickupController(dataProvider: MockPickupProvider())
        XCTAssertEqual(pickupController.pickups.count, 3)
        XCTAssertNil(pickupController.error)
    }

    func testPickupControllerFailure() throws {
        let pickupController = PickupController(dataProvider: MockPickupProvider(shouldFail: true))
        XCTAssert(pickupController.pickups.isEmpty)
        XCTAssertNotNil(pickupController.error)
    }
}
