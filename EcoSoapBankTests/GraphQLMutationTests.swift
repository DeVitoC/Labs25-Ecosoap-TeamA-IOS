//
//  GraphQLMutationTests.swift
//  EcoSoapBankTests
//
//  Created by Christopher Devito on 8/22/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import EcoSoapBank

class GraphQLMutationTests: XCTestCase {

    func testLogin() {
        guard let path = Bundle.main.path(forResource: "mockUserByIdInput",
                                          ofType: "json"),
            let mockData = NSData(contentsOfFile: path) else {
                XCTFail("Unable to get mock impact stats data from path")
                return
        }
        let data = Data(mockData)
        let mockLoader = MockDataLoader(data: data,
                                        error: nil)
        let graphQLController = GraphQLController(session: mockLoader)

        graphQLController.queryRequest(User.self, query: GraphQLMutations.login) { result in

            guard let result = try? result.get(),
                let propertyId = result.properties?[0].id,
                let services = result.properties?[0].services,
                let collectionType = result.properties?[0].collectionType else {
                    XCTFail("Unable to get valid impact stats from returned data")
                    return
            }
            let userId = result.id
            let firstName = result.firstName
            let lastName = result.lastName

            XCTAssert(userId == "4")
            XCTAssert(firstName == "Christopher")
            XCTAssert(lastName == "DeVito")
            XCTAssert(propertyId == "5")
            XCTAssert(services == [.bottles, .linens, .paper, .soap])
            XCTAssert(collectionType == .courierConsolidated)
        }
    }

    func testSchedulePickup() {
        guard let path = Bundle.main.path(forResource: "mockUserByIdInput",
                                          ofType: "json"),
            let mockData = NSData(contentsOfFile: path) else {
                XCTFail("Unable to get mock impact stats data from path")
                return
        }
        let data = Data(mockData)
        let mockLoader = MockDataLoader(data: data,
                                        error: nil)
        let graphQLController = GraphQLController(session: mockLoader)

        graphQLController.queryRequest(Pickup.ScheduleResult.self, query: GraphQLMutations.schedulePickup) { result in

            guard let result = try? result.get(),
                let propertyId = result.properties?[0].id,
                let services = result.properties?[0].services,
                let collectionType = result.properties?[0].collectionType else {
                    XCTFail("Unable to get valid impact stats from returned data")
                    return
            }
            let userId = result.id
            let firstName = result.firstName
            let lastName = result.lastName

            XCTAssert(userId == "4")
            XCTAssert(firstName == "Christopher")
            XCTAssert(lastName == "DeVito")
            XCTAssert(propertyId == "5")
            XCTAssert(services == [.bottles, .linens, .paper, .soap])
            XCTAssert(collectionType == .courierConsolidated)
        }
    }

    func testCancelPickupRequest() {
        guard let path = Bundle.main.path(forResource: "mockUserByIdInput",
                                          ofType: "json"),
            let mockData = NSData(contentsOfFile: path) else {
                XCTFail("Unable to get mock impact stats data from path")
                return
        }
        let data = Data(mockData)
        let mockLoader = MockDataLoader(data: data,
                                        error: nil)
        let graphQLController = GraphQLController(session: mockLoader)

        graphQLController.queryRequest(User.self, query: GraphQLMutations.login) { result in

            guard let result = try? result.get(),
                let propertyId = result.properties?[0].id,
                let services = result.properties?[0].services,
                let collectionType = result.properties?[0].collectionType else {
                    XCTFail("Unable to get valid impact stats from returned data")
                    return
            }
            let userId = result.id
            let firstName = result.firstName
            let lastName = result.lastName

            XCTAssert(userId == "4")
            XCTAssert(firstName == "Christopher")
            XCTAssert(lastName == "DeVito")
            XCTAssert(propertyId == "5")
            XCTAssert(services == [.bottles, .linens, .paper, .soap])
            XCTAssert(collectionType == .courierConsolidated)
        }
    }

}
