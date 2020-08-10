//
//  UtilityTests.swift
//  EcoSoapBankTests
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
// swiftlint:disable nesting

import XCTest
@testable import EcoSoapBank


class UtilityTests: XCTestCase {

    func testConfigure() {
        class TestObject {
            var int = 0
        }
        
        let int = configure(9) { $0 += 1 }
        XCTAssertEqual(int, 10)

        let object = configure(TestObject()) {
            let x = 30 * 2
            $0.int *= 234
            $0.int = x - 18
        }
        XCTAssertEqual(object.int, 42)
    }
}
