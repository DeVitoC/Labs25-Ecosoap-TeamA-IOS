//
//  GraphQLControllerTests.swift
//  EcoSoapBankTests
//
//  Created by Christopher Devito on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import EcoSoapBank

class GraphQLControllerTests: XCTestCase {

    func testQueryRequestWithMockDataSuccess() {
        guard let path = Bundle.main.path(forResource: "mockImpactStatsByPropertyId",
                                          ofType: "json"),
            let mockData = NSData(contentsOfFile: path) else {
                NSLog("Unable to get data from mockImpactStatsByPropertyId.json")
                return
        }
        let data = Data(mockData)
        let mockLoader = MockDataLoader(data: data,
                                        error: nil)
        let graphQLController = GraphQLController(session: mockLoader)

        graphQLController.queryRequest(ImpactStats.self, query: GraphQLQueries.impactStatsByPropery) { result in

            guard let result = try? result.get() else {
                NSLog("result did not cocntain valid Impact stats")
                return
            }

            XCTAssert(Int(result.amountString(for: .soapRecycled)!) == 1)
            XCTAssert(Int(result.amountString(for: .linensRecycled)!) == 2)
            XCTAssert(Int(result.amountString(for: .bottlesRecycled)!) == 3)
            XCTAssert(Int(result.amountString(for: .paperRecycled)!) == 4)
            XCTAssert(Int(result.amountString(for: .peopleServed)!) == 5)
            XCTAssert(Int(result.amountString(for: .womenEmployed)!) == 6)
        }
    }

}
