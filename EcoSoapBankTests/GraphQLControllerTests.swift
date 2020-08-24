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

    func setDataLoader(file: String) -> GraphQLController {
        guard let path = Bundle.main.path(forResource: file,
                                          ofType: "json"),
            let mockData = NSData(contentsOfFile: path) else {
                XCTFail("Unable to get mock data from path")
                return GraphQLController()
        }
        let data = Data(mockData)
        let mockLoader = MockDataLoader(data: data,
                                        error: nil)
        return GraphQLController(session: mockLoader)
    }

    func testImpactStatsQueryRequestWithMockDataSuccess() {
        let graphQLController = setDataLoader(file: "mockImpactStatsByPropertyId")

        graphQLController.queryRequest(ImpactStats.self, query: GraphQLQueries.impactStatsByPropery) { result in

            guard let result = try? result.get(),
                let soapRecycled = result.soapRecycled,
                let linensRecycled = result.linensRecycled,
                let bottlesRecycled = result.bottlesRecycled,
                let paperRecycled = result.paperRecycled,
                let peopleServed = result.peopleServed,
                let womenEmployed = result.womenEmployed else {
                    XCTFail("Unable to get valid impact stats from returned data")
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
        let graphQLController = setDataLoader(file: "mockImpactStatsFailure")

        graphQLController.queryRequest(ImpactStats.self, query: GraphQLQueries.impactStatsByPropery) { result in

            XCTAssertNil(try? result.get())
        }
    }

    func testUserByIdQueryRequestWithMockDataSuccess() {
        let graphQLController = setDataLoader(file: "mockUserByIdInput")

        graphQLController.queryRequest(User.self, query: GraphQLQueries.userById) { result in

            guard let result = try? result.get() else {
                XCTFail("Unable to get valid User from returned data")
                return
            }
            let id = result.id
            let firstName = result.firstName
            let lastName = result.lastName
            let title = result.title
            let company = result.company
            let email = result.email

            XCTAssert(id == "4")
            XCTAssert(firstName == "Christopher")
            XCTAssert(lastName == "DeVito")
            XCTAssert(title == "Manager")
            XCTAssert(company == "Hilton")
            XCTAssert(email == "email@email.com")
        }
    }

    func testPickupsByPropertyIdWithMockDataSuccess() {
        let graphQLController = setDataLoader(file: "mockPickupsByPropertyIdSuccess")

        graphQLController.queryRequest([Pickup].self, query: GraphQLQueries.pickupsByPropertyId) { result in

            guard let result = try? result.get() else {
                XCTFail("Unable to get Pickup from returned data")
                return
            }

            let id1 = result[0].id
            let confirmationCode1 = result[0].confirmationCode
            let collectionType1 = result[0].collectionType
            let property1ID = result[0].property.id
            let cartons1ID = result[0].cartons[0].id
            let notes1 = result[0].notes
            let id2 = result[1].id
            let confirmationCode2 = result[1].confirmationCode
            let collectionType2 = result[1].collectionType
            let property2ID = result[1].property.id
            let cartons2ID = result[1].cartons[0].id
            let notes2 = result[1].notes

            XCTAssert(id1 == "4")
            XCTAssert(confirmationCode1 == "Success")
            XCTAssert(collectionType1.rawValue == "LOCAL")
            XCTAssert(property1ID == "5")
            XCTAssert(cartons1ID == "6")
            XCTAssert(notes1 == "Pickup notes here")
            XCTAssert(id2 == "7")
            XCTAssert(confirmationCode2 == "Success")
            XCTAssert(collectionType2.rawValue == "COURIER_CONSOLIDATED")
            XCTAssert(property2ID == "5")
            XCTAssert(cartons2ID == "8")
            XCTAssert(notes2 == "Pickup2 notes here")
        }
    }

    func testPropertiesByUserIdWithMockDataSuccess() {
        let graphQLController = setDataLoader(file: "mockPropertiesByUserIdSuccess")

        graphQLController.queryRequest([Property].self, query: GraphQLQueries.propertiesByUserId) { result in

            guard let result = try? result.get() else {
                XCTFail("Unable to get Properties from returned data")
                return
            }

            let propertyId = result[0].id
            let propertyType = result[0].propertyType
            let rooms = result[0].rooms
            let services = result[0].services
            let phone = result[0].phone
            let billingCity = result[0].billingAddress?.city
            let shippingCity = result[0].shippingAddress?.city
            let shippingNote = result[0].shippingNote

            XCTAssert(propertyId == "PropertyId1")
            XCTAssert(propertyType == .hotel)
            XCTAssert(rooms == 111)
            XCTAssert(services == [.soap, .linens])
            XCTAssert(phone == "111-111-1111")
            XCTAssert(billingCity == "City 5")
            XCTAssert(shippingCity == "City 5")
            XCTAssert(shippingNote == "Shipping note 1.")
        }
    }
}
