//
//  ImpactCellViewModelTests.swift
//  EcoSoapBankTests
//
//  Created by Shawn Gee on 8/21/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

@testable import EcoSoapBank
import XCTest

class ImpactCellViewModelTests: XCTestCase {

    func testInitWithPeople() {
        let vm = ImpactCellViewModel(amount: 20,
                                     unit: .people,
                                     subtitle: "description of people",
                                     image: .people)
        
        XCTAssertEqual(vm.amount, 20)
        XCTAssertEqual(vm.unit, ImpactCellViewModel.Unit.people)
        XCTAssertEqual(vm.subtitle, "description of people")
        XCTAssertEqual(vm.image, UIImage.people)
        XCTAssertEqual(vm.title, "20")
    }
    
    func testInitWithWeight() {
        let vm = ImpactCellViewModel(amount: 1000,
                                     unit: .grams,
                                     subtitle: "description of weight",
                                     image: .soap)
        
        XCTAssertEqual(vm.amount, 1000)
        XCTAssertEqual(vm.unit, ImpactCellViewModel.Unit.grams)
        XCTAssertEqual(vm.subtitle, "description of weight")
        XCTAssertEqual(vm.image, UIImage.soap)
        XCTAssertEqual(vm.title, "2.2 lb")
    }
}
