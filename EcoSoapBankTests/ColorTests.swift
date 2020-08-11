//
//  ColorTests.swift
//  EcoSoapBankTests
//
//  Created by Shawn Gee on 8/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//


import XCTest
@testable import EcoSoapBank

class ColorTests: XCTestCase {
    
    func testColorsInitializeProperly() {
        XCTAssertNotNil(UIColor.esbGreen)
        XCTAssertNotNil(UIColor.downyBlue)
        XCTAssertNotNil(UIColor.codGrey)
        XCTAssertNotNil(UIColor.montanaGrey)
        XCTAssertNotNil(UIColor.shuttleGrey)
        XCTAssertNotNil(UIColor.silver)
    }
}
