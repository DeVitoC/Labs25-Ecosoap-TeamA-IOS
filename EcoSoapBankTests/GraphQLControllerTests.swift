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

    func testImpactStatsQueryRequestWithMockDataSuccess() {
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

            guard let result = try? result.get(),
                let soapRecycled = result.soapRecycled,
                let linensRecycled = result.linensRecycled,
                let bottlesRecycled = result.bottlesRecycled,
                let paperRecycled = result.paperRecycled,
                let peopleServed = result.peopleServed,
                let womenEmployed = result.womenEmployed else {
                NSLog("result did not cocntain valid Impact stats")
                return
            }

            XCTAssert(soapRecycled == 1)
            XCTAssert(linensRecycled == 2)
            XCTAssert(bottlesRecycled == 3)
            XCTAssert(paperRecycled == 4)
            XCTAssert(peopleServed == 5)
            XCTAssert(womenEmployed == 6)
        }
    }

    func testQueryRequestWithMockDataFailure() {
        guard let path = Bundle.main.path(forResource: "mockImpactStatsFailure",
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

            let soapRecycled = result.soapRecycled
            let linensRecycled = result.linensRecycled
            let bottlesRecycled = result.bottlesRecycled
            let paperRecycled = result.paperRecycled
            let peopleServed = result.peopleServed
            let womenEmployed = result.womenEmployed

            XCTAssertNil(soapRecycled)
            XCTAssertNil(linensRecycled)
            XCTAssertNil(bottlesRecycled)
            XCTAssertNil(paperRecycled)
            XCTAssertNil(peopleServed)
            XCTAssertNil(womenEmployed)
        }
    }

    func testUserByIdQueryRequestWithMockDataSuccess() {
        guard let path = Bundle.main.path(forResource: "mockUserByIdInput",
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

            guard let result = try? result.get(),
                let soapRecycled = result.soapRecycled,
                let linensRecycled = result.linensRecycled,
                let bottlesRecycled = result.bottlesRecycled,
                let paperRecycled = result.paperRecycled,
                let peopleServed = result.peopleServed,
                let womenEmployed = result.womenEmployed else {
                    NSLog("result did not cocntain valid Impact stats")
                    return
            }

            XCTAssert(soapRecycled == 1)
            XCTAssert(linensRecycled == 2)
            XCTAssert(bottlesRecycled == 3)
            XCTAssert(paperRecycled == 4)
            XCTAssert(peopleServed == 5)
            XCTAssert(womenEmployed == 6)
        }
    }


}
