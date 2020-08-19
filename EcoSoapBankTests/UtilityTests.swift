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

    func testDateConvenienceInit() {
        let date = Date(year: 2020, month: 3, day: 19, hour: 8, minute: 56)
        XCTAssertNotNil(date, "Expected non-nil date from initializer")

        let components = Calendar.current.dateComponents(in: .current, from: date!)
        XCTAssertEqual(components.year, 2020)
        XCTAssertEqual(components.month, 3)
        XCTAssertEqual(components.day, 19)
        XCTAssertEqual(components.hour, 8)
        XCTAssertEqual(components.minute, 56)
    }
    
    func testWeightStringDefaultsToLocale() {
        UserDefaults.massUnit = nil
        
        let weightString = Measurement(value: 1000, unit: UnitMass.grams).string
        
        XCTAssertEqual(weightString, "2.2 lb")
    }
    
    func testWeightIsDisplayedAsKilograms() {
        UserDefaults.massUnit = UnitMass.kilograms.symbol
        
        let weightString = Measurement(value: 1000, unit: UnitMass.grams).string
        
        XCTAssertEqual(weightString, "1 kg")
    }
    
    func testWeightIsDisplayedAsPounds() {
        UserDefaults.massUnit = UnitMass.pounds.symbol
        
        let weightString = Measurement(value: 1000, unit: UnitMass.grams).string
        
        XCTAssertEqual(weightString, "2.2 lb")
    }
}
