//
//  FontsTests.swift
//  EcoSoapBankTests
//
//  Created by Shawn Gee on 8/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import EcoSoapBank

class FontTests: XCTestCase {

    func testMuliFontsInitializeProperly() {
        // given
        for style in UIFont.MuliStyle.allCases {
            
            // when
            let font = UIFont(name: "Muli\(style.rawValue)", size: 20)
            
            // then
            XCTAssertNotNil(font, "Could not initialize Muli font with style: \(style)")
        }
    }
    
    func testMuliFontStaticFunc() {
        // given
        let desiredFontName = "Muli-BoldItalic"
        
        // when
        let font: UIFont = .muli(ofSize: 20, style: .boldItalic)
        
        // then
        XCTAssertEqual(font.fontName, desiredFontName)
    }
    
    func testMontserratFontsInitializeProperly() {
        // given
        for style in UIFont.MontserratStyle.allCases {
            
            // when
            let font = UIFont(name: "Montserrat\(style.rawValue)", size: 20)
            
            // then
            XCTAssertNotNil(font, "Could not initialize Montserrat font with style: \(style)")
        }
    }
    
    func testMontserratFontStaticFunc() {
        // given
        let desiredFontName = "Montserrat-BoldItalic"
        
        // when
        let font: UIFont = .montserrat(ofSize: 20, style: .boldItalic)
        
        // then
        XCTAssertEqual(font.fontName, desiredFontName)
    }

}
