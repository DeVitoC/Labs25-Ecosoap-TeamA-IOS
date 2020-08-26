//
//  ImpactViewControllerTests.swift
//  EcoSoapBankTests
//
//  Created by Shawn Gee on 8/21/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

@testable import EcoSoapBank
import ObjectiveC
import XCTest

class ImpactViewControllerTest: XCTestCase {

    var impactVC: ImpactViewController!
    
    override func setUp() {
        super.setUp()
        
        impactVC = ImpactViewController()
        impactVC.impactController = ImpactController(user: .placeholder(), dataProvider: MockImpactProvider())
        // load view hierarchy
        _ = impactVC.view
    }
    
    func testCanInstantiateViewController() {
        XCTAssertNotNil(impactVC)
    }
    
    func testCollectionViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(impactVC.collectionView)
    }
    
    func testShouldSetCollectionViewDataSource() {
        XCTAssertNotNil(impactVC.collectionView.dataSource)
    }
    
    func testConformsToCollectionViewDataSource() {
        XCTAssert(ImpactViewController.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(impactVC.responds(to: #selector(impactVC.collectionView(_:viewForSupplementaryElementOfKind:at:))))
        XCTAssertTrue(impactVC.responds(to: #selector(impactVC.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(impactVC.responds(to: #selector(impactVC.collectionView(_:cellForItemAt:))))
    }
    
    func testShouldSetCollectionViewDelegate() {
        XCTAssertNotNil(impactVC.collectionView.delegate)
    }
    
    func testConformsToCollectionViewDelegateFlowLayout () {
        XCTAssertTrue(impactVC.conforms(to: UICollectionViewDelegateFlowLayout.self))
        XCTAssertTrue(impactVC.responds(to: #selector(impactVC.collectionView(_:layout:referenceSizeForHeaderInSection:))))
        XCTAssertTrue(impactVC.responds(to: #selector(impactVC.collectionView(_:layout:sizeForItemAt:))))
        XCTAssertTrue(impactVC.responds(to: #selector(impactVC.collectionView(_:layout:insetForSectionAt:))))
    }
}
