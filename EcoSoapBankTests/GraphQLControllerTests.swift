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
                NSLog("result did not contain valid Impact stats")
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

    func testImpactStatsQueryRequestWithMockDataFailure() {
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
                    NSLog("result did not contain valid Impact stats")
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

        graphQLController.queryRequest(User.self, query: GraphQLQueries.userById) { result in

            guard let result = try? result.get() else {
                    NSLog("result did not contain valid user data")
                    return
            }
            let id = result.id
            let firstName = result.firstName
            let lastName = result.lastName
            let title = result.title
            let company = result.company
            let email = result.email

            XCTAssert(id == 4)
            XCTAssert(firstName == "Christopher")
            XCTAssert(lastName == "DeVito")
            XCTAssert(title == "Manager")
            XCTAssert(company == "Hilton")
            XCTAssert(email == "email@email.com")
        }
    }


}
