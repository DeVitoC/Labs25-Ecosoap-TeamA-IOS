//
//  Fonts.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIFont {
    enum MuliTypeface: String, CaseIterable {
        case extraLight = "-ExtraLight"
        case extraLightItalic = "-ExtraLightItalic"
        case boldItalic = "-BoldItalic"
        case semiBoldItalic = "-Semi-BoldItalic"
        case bold = "-Bold"
        case italic = "-Italic"
        case semiBold = "-SemiBold"
        case light = "-Light"
        case regular = ""
        case lightItalic = "-LightItalic"
    }
    
    static func muli(ofSize size: CGFloat, typeface: MuliTypeface = .regular) -> UIFont {
        UIFont(name: .muli + typeface.rawValue, size: size)!.scaled()
    }
    
    enum MontserratTypeface: String, CaseIterable {
        case mediumItalic = "-MediumItalic"
        case bold = "-Bold"
        case blackItalic = "-BlackItalic"
        case boldItalic = "-BoldItalic"
        case light = "-Light"
        case thinItalic = "-ThinItalic"
        case thin = "-Thin"
        case extraLight = "-ExtraLight"
        case lightItalic = "-LightItalic"
        case medium = "-Medium"
        case semiBoldItalic = "-SemiBoldItalic"
        case extraBoldItalic = "-ExtraBoldItalic"
        case italic = "-Italic"
        case regular = "-Regular"
        case extraBold = "-ExtraBold"
        case extraLightITalic = "-ExtraLightItalic"
        case black = "-Black"
        case semiBold = "-SemiBold"
    }
    
    static func montserrat(ofSize size: CGFloat, typeface: MontserratTypeface = .regular) -> UIFont {
        UIFont(name: .montserrat + typeface.rawValue, size: size)!.scaled()
    }
}


extension UIFont {
    func scaled() -> UIFont {
        UIFontMetrics.default.scaledFont(for: self)
    }

    enum Montserrat {
        static var navBarLargeTitle: UIFont {
            .montserrat(ofSize: 30, typeface: .semiBold)
        }

        static var navBarInlineTitle: UIFont {
            .montserrat(ofSize: 18, typeface: .semiBold)
        }
    }
}


extension String {
    static let montserrat = "Montserrat"
    static let muli = "Muli"
}
