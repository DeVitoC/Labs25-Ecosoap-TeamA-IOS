//
//  GraphQLControllerTests.swift
//  EcoSoapBankTests
//
//  Created by Christopher Devito on 8/22/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import EcoSoapBank

class GraphQLControllerTests: XCTestCase {

    func testImpactStatsQuerySuccess() {
        let expectation = XCTestExpectation(description: "Get response from backend API")
        let graphQLController = GraphQLController()

        graphQLController.fetchImpactStats(forPropertyID: "PropertyId1") { result in

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

            XCTAssert(soapRecycled == 11)
            XCTAssert(linensRecycled == 11)
            XCTAssert(bottlesRecycled == 11)
            XCTAssert(paperRecycled == 11)
            XCTAssert(peopleServed == 11)
            XCTAssert(womenEmployed == 11)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testImpactStatsQueryFailure() {
        let expectation = XCTestExpectation(description: "Get response from backend API")
        let graphQLController = GraphQLController()

        graphQLController.fetchImpactStats(forPropertyID: "PropertyIId1") { result in

            XCTAssertNil(try? result.get())
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testUserByIdQuerySuccess() {
        let expectation = XCTestExpectation(description: "Get response from backend API")
        let graphQLController = GraphQLController()

        graphQLController.fetchUser(byID: "UserId1") { result in

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

            XCTAssert(id == "UserId1")
            XCTAssert(firstName == "First Name 1")
            XCTAssert(lastName == "Last Name 1")
            XCTAssert(title == "Title 1")
            XCTAssert(company == "Company 1")
            XCTAssert(email == "Email 1")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testPickupsByPropertyIdSuccess() {
        let expectation = XCTestExpectation(description: "Get response from backend API")
        let graphQLController = GraphQLController()

        graphQLController.fetchPickups(forPropertyID: "PropertyId1") { result in

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
            
            XCTAssert(id1 == "PickupId1")
            XCTAssert(confirmationCode1 == "PickupConfirmationCode1")
            XCTAssert(collectionType1 == .generatedLabel)
            XCTAssert(property1ID == "PropertyId1")
            XCTAssert(cartons1ID == "PickupCartonId1")
            XCTAssert(notes1 == "Pickup Notes 1")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testPropertiesByUserIdSuccess() {
        let expectation = XCTestExpectation(description: "Get response from backend API")
        let graphQLController = GraphQLController()

        graphQLController.fetchProperties(forUserID: "UserId1") { result in

            guard let result = try? result.get() else {
                XCTFail("Unable to get Properties from returned data")
                return
            }

            let propertyId = result[0].id
            let propertyType = result[0].propertyType
            let rooms = result[0].rooms
            let services = result[0].services
            let phone = result[0].phone
            let shippingNote = result[0].shippingNote

            XCTAssert(propertyId == "PropertyId1")
            XCTAssert(propertyType == .hotel)
            XCTAssert(rooms == 111)
            XCTAssert(services == [.soap, .linens])
            XCTAssert(phone == "111-111-1111")
            XCTAssert(shippingNote == "Shipping note 1.")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testSchedulePickup() {
        let expectation = XCTestExpectation(description: "Get response from backend API")
        let graphQLController = GraphQLController()
        let scheuleInput = Pickup.ScheduleInput(base: Pickup.Base(collectionType: .generatedLabel,
                                                                  status: .submitted,
                                                                  readyDate: Date(year: 2020,
                                                                                  month: 08,
                                                                                  day: 25,
                                                                                  hour: 1,
                                                                                  minute: 1)!,
                                                                  pickupDate: nil,
                                                                  notes: nil),
                                                propertyID: "PropertyId1",
                                                cartons: [Pickup.CartonContents(product: .soap,
                                                                                percentFull: 100)])
        
        graphQLController.schedulePickup(scheuleInput) { result in
            
            guard let result = try? result.get() else {
                XCTFail("Unable to get valid Pickup data from returned data")
                return
            }
            
            let status = result.pickup?.status
            let cartonProduct = result.pickup?.cartons[0].contents?.product
            let cartonPercentFull = result.pickup?.cartons[0].contents?.percentFull
            let collectionType = result.pickup?.collectionType
            let label = result.labelURL
            
            XCTAssertEqual(status, .submitted)
            XCTAssertEqual(cartonProduct, .soap)
            XCTAssertEqual(cartonPercentFull, 100)
            XCTAssertEqual(collectionType, .generatedLabel)
            XCTAssertEqual(label?.absoluteString, "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCancelPickupRequest() {
        let expectation = XCTestExpectation(description: "Get response from backend API")
        let graphQLController = GraphQLController()

        graphQLController.cancelPickup("PickupId1") { result in

            guard let result = try? result.get() else {
                XCTFail("Unable to get valid Pickup from returned data")
                return
            }

            let pickupId = result.id
            let confirmationCode = result.confirmationCode
            let collectionType = result.collectionType
            let propertyId = result.property.id
            let cartonId = result.cartons[0].id
            let cartonPercentFull = result.cartons[0].contents?.percentFull

            XCTAssert(pickupId == "PickupId1")
            XCTAssert(confirmationCode == "PickupConfirmationCode1")
            XCTAssert(collectionType == .generatedLabel)
            XCTAssert(propertyId == "PropertyId1")
            XCTAssert(cartonId == "PickupCartonId1")
            XCTAssert(cartonPercentFull == 11)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
