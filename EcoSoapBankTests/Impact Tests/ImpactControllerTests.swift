//
//  ImpactControllerTests.swift
//  EcoSoapBankTests
//
//  Created by Shawn Gee on 8/21/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

@testable import EcoSoapBank
import XCTest

class ImpactControllerTests: XCTestCase {
    
    func testViewModelsEmptyOnInit() {
        let dataProvider = MockImpactProvider()
        let impactController = ImpactController(user: .placeholder(), dataProvider: dataProvider)
        
        XCTAssertTrue(impactController.viewModels.isEmpty)
    }
    
    func testImpactProviderSuccess() {
        let impactController = ImpactController(user: .placeholder(), dataProvider: MockImpactProvider())
        let expectation = XCTestExpectation(description: "Wait for mock data")
        
        impactController.getImpactStats { error in
            XCTAssertNil(error)
            XCTAssertEqual(impactController.viewModels.count, 6)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testImpactProviderFailure() {
        let impactController = ImpactController(user: .placeholder(), dataProvider: MockImpactProvider(shouldFail: true))
        let expectation = XCTestExpectation(description: "Wait for mock data")
        
        impactController.getImpactStats { error in
            XCTAssertEqual(error as? MockError, MockError.shouldFail)
            XCTAssertEqual(impactController.viewModels.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
