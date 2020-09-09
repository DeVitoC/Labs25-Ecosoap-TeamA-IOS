//
//  UserDefaultsTests.swift
//  EcoSoapBankTests
//
//  Created by Shawn Gee on 9/9/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

import XCTest
@testable import EcoSoapBank

class UserDefaultsTests: XCTestCase {
    
    static let testKey = Key("testKey")
    @UserDefault(testKey) var testDefault: Bool?
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.set(nil, forKey: Self.testKey.rawValue)
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.set(nil, forKey: Self.testKey.rawValue)
    }
    
    func testSettingUserDefaultWithPropertyWrapper() {
        testDefault = true
        
        guard let testTrue = UserDefaults.standard.value(forKey: Self.testKey.rawValue) as? Bool else {
            XCTFail("Unable to get user default")
            return
        }
        
        XCTAssertTrue(testTrue)
        
        testDefault = false
        
        guard let testFalse = UserDefaults.standard.value(forKey: Self.testKey.rawValue) as? Bool else {
            XCTFail("Unable to get user default")
            return
        }
        
        XCTAssertFalse(testFalse)
    }
    
    func testGettingUserDefaultWithPropertyWrapper() {
        UserDefaults.standard.set(true, forKey: Self.testKey.rawValue)
        
        guard let testTrue = testDefault else {
            XCTFail("Unable to get user default with property wrapper")
            return
        }
        
        XCTAssertTrue(testTrue)
        
        UserDefaults.standard.set(false, forKey: Self.testKey.rawValue)
        
        guard let testFalse = testDefault else {
            XCTFail("Unable to get user default with property wrapper")
            return
        }
        
        XCTAssertFalse(testFalse)
    }
    
    func testObservingUserDefaultChange() {
        let expectation = XCTestExpectation(description: "Wait for observation")
        
        testDefault = false
        
        let observation = $testDefault.observe { old, new in
            guard let old = old, let new = new else {
                XCTFail("Unable to unwrap old and new values")
                return
            }
            
            XCTAssertFalse(old)
            XCTAssertTrue(new)
            expectation.fulfill()
        }
        
        testDefault = true
        
        wait(for: expectation, timeout: 1)
        
        print("Successfully observed \(observation.key.rawValue)")
    }
}
