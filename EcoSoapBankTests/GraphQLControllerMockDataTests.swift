//
//  GraphQLControllerMockDataTests.swift
//  EcoSoapBankTests
//
//  Created by Christopher Devito on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.


import XCTest
@testable import EcoSoapBank

class GraphQLControllerMockDataTests: XCTestCase {
    
    func dataLoader(withFile file: String) -> GraphQLController {
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

    // MARK: - Impact
    
    func testImpactStatsQueryRequestWithMockDataSuccess() {
        let graphQLController = dataLoader(withFile: "mockImpactStatsByPropertyId")

        graphQLController.fetchImpactStats(forPropertyID: "PropertyId1") { result in

            guard let impactStats = try? result.get() else {
                    XCTFail("Unable to get valid impact stats from returned data")
                    return
            }

            XCTAssertEqual(impactStats.soapRecycled, 1)
            XCTAssertEqual(impactStats.linensRecycled, 2)
            XCTAssertEqual(impactStats.bottlesRecycled, 3)
            XCTAssertEqual(impactStats.paperRecycled, 4)
            XCTAssertEqual(impactStats.peopleServed, 5)
            XCTAssertEqual(impactStats.womenEmployed, 6)
        }
    }

    func testImpactStatsQueryRequestWithMockDataFailure() {
        let graphQLController = dataLoader(withFile: "mockImpactStatsFailure")

        graphQLController.fetchImpactStats(forPropertyID: "PropertyId1") { result in
            XCTAssertNil(try? result.get())
        }
    }
    
    func testUserByIdQueryRequestWithMockDataSuccess() {
        let graphQLController = dataLoader(withFile: "mockUserByIdInput")
        
        graphQLController.fetchUser(byID: "UserId1") { result in
            
            guard let user = try? result.get() else {
                XCTFail("Unable to get valid User from returned data")
                return
            }
            
            XCTAssertEqual(user.id, "4")
            XCTAssertEqual(user.firstName, "Christopher")
            XCTAssertEqual(user.lastName, "DeVito")
            XCTAssertEqual(user.title, "Manager")
            XCTAssertEqual(user.company, "Hilton")
            XCTAssertEqual(user.email, "email@email.com")
        }
    }

    func testPickupsByPropertyIdWithMockDataSuccess() {
        let graphQLController = dataLoader(withFile: "mockPickupsByPropertyIdSuccess")

        graphQLController.fetchPickups(forPropertyID: "PropertyId1") { result in
            
            guard let pickups = try? result.get() else {
                XCTFail("Unable to get Pickups from returned data")
                return
            }
            
            let firstPickup = pickups[0]
            let secondPickup = pickups[1]
            
            XCTAssertEqual(firstPickup.id, "4")
            XCTAssertEqual(firstPickup.confirmationCode, "Success")
            XCTAssertEqual(firstPickup.collectionType, .local)
            XCTAssertEqual(firstPickup.property.id, "5")
            XCTAssertEqual(firstPickup.cartons[0].id, "6")
            XCTAssertEqual(firstPickup.notes, "Pickup notes here")
            
            XCTAssertEqual(secondPickup.id, "7")
            XCTAssertEqual(secondPickup.confirmationCode, "Success")
            XCTAssertEqual(secondPickup.collectionType, .courierConsolidated)
            XCTAssertEqual(secondPickup.property.id, "5")
            XCTAssertEqual(secondPickup.cartons[0].id, "8")
            XCTAssertEqual(secondPickup.notes, "Pickup2 notes here")
        }
    }

    func testPropertiesByUserIdWithMockDataSuccess() {
        let graphQLController = dataLoader(withFile: "mockPropertiesByUserIdSuccess")

        graphQLController.fetchProperties(forUserID: "UserId1") { result in
            
            guard let firstProperty = try? result.get().first else {
                XCTFail("Unable to get Properties from returned data")
                return
            }
            
            XCTAssertEqual(firstProperty.id, "PropertyId1")
            XCTAssertEqual(firstProperty.propertyType, .hotel)
            XCTAssertEqual(firstProperty.rooms, 111)
            XCTAssertEqual(firstProperty.services, [.soap, .linens])
            XCTAssertEqual(firstProperty.phone, "111-111-1111")
            XCTAssertEqual(firstProperty.billingAddress?.city, "City 5")
            XCTAssertEqual(firstProperty.shippingAddress?.city, "City 5")
            XCTAssertEqual(firstProperty.shippingNote, "Shipping note 1.")
        }
    }

    func testLoginWithMockData() {
        let graphQLController = dataLoader(withFile: "mockUserByIdInput")

        graphQLController.logIn { result in

            guard let user = try? result.get(),
                let property = user.properties?.first else {
                    XCTFail("Unable to get user from returned data")
                    return
            }
            
            XCTAssertEqual(user.id, "4")
            XCTAssertEqual(user.firstName, "Christopher")
            XCTAssertEqual(user.lastName, "DeVito")
            XCTAssertEqual(property.id, "5")
            XCTAssertEqual(property.services, [.bottles, .linens, .paper, .soap])
            XCTAssertEqual(property.collectionType, .courierConsolidated)
        }
    }

    func testSchedulePickupWithMockData() {
        let graphQLController = dataLoader(withFile: "mockSchedulePickupSuccess")
        
        let readyDate = Date(year: 2020, month: 09, day: 25, hour: 1, minute: 1)!
        let scheduleInput = Pickup.ScheduleInput(
            base: Pickup.Base(collectionType: .local,
                              status: .complete,
                              readyDate: readyDate,
                              pickupDate: nil,
                              notes: nil),
            propertyID: "PropertyId1",
            cartons: [Pickup.CartonContents(product: .soap, percentFull: 100)]
        )
        
        graphQLController.schedulePickup(scheduleInput) { result in
            
            guard let scheduleResult = try? result.get(),
                let pickup = scheduleResult.pickup,
                let labelURL = scheduleResult.labelURL else {
                    XCTFail("Unable to get valid impact stats from returned data")
                    return
            }
            
            XCTAssertEqual(pickup.id, "PickupId1")
            XCTAssertEqual(pickup.confirmationCode, "Success")
            XCTAssertEqual(pickup.status, .complete)
            XCTAssertEqual(pickup.cartons.first?.id, "CartonId1")
            XCTAssertEqual(pickup.collectionType, .local)
            XCTAssertEqual(pickup.id, "PickupId1")
            XCTAssertEqual(labelURL.absoluteString, "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")
        }
    }

    func testCancelPickupRequestWithMockData() {
        let graphQLController = dataLoader(withFile: "mockCancelPickupSuccess")

        graphQLController.cancelPickup("PickupId1") { result in
            
            guard let pickup = try? result.get(),
                let firstCarton = pickup.cartons.first else {
                    XCTFail("Unable to get valid impact stats from returned data")
                    return
            }
            
            XCTAssertEqual(pickup.id, "PickupId1")
            XCTAssertEqual(pickup.confirmationCode, "Success")
            XCTAssertEqual(pickup.collectionType, .local)
            XCTAssertEqual(pickup.property.id, "PropertyId1")
            XCTAssertEqual(firstCarton.id, "CartonId1")
            XCTAssertEqual(firstCarton.contents?.percentFull, 100)
        }
    }
}
