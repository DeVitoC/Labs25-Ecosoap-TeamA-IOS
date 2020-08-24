//
//  ImpactCellTests.swift
//  EcoSoapBankTests
//
//  Created by Shawn Gee on 8/21/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

@testable import EcoSoapBank
import XCTest

class ImpactCellTests: XCTestCase {

    var cell: ImpactCell!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var imageView: ESBCircularImageView!
    
    override func setUp() {
        super.setUp()
        cell = ImpactCell()
        titleLabel = cell.contentView.subviews[0] as? UILabel
        subtitleLabel = cell.contentView.subviews[1] as? UILabel
        imageView = cell.contentView.subviews[2] as? ESBCircularImageView
        
        cell.viewModel = ImpactCellViewModel(amount: 10,
                                             unit: .people,
                                             subtitle: "This is the subtitle",
                                             image: .people)
    }
    
    func testInit() {
        print(cell.subviews)
        XCTAssertNotNil(cell)
        XCTAssertNotNil(titleLabel)
        XCTAssertNotNil(subtitleLabel)
        XCTAssertNotNil(imageView)
    }
    
    func testTitleLabelIsProperlySet() {
        XCTAssertEqual(titleLabel.text, "10")
    }
    
    func testSubtitleLabelIsProperlySet() {
        XCTAssertEqual(subtitleLabel.text, "This is the subtitle")
    }
    
    func testImageIsProperlySet() {
        XCTAssertEqual(imageView.image, .people)
    }
}
