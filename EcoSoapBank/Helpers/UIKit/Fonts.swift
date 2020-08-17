//
//  Fonts.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum MuliStyle: String, CaseIterable {
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
    
    static func muli(ofSize size: CGFloat, style: MuliStyle = .regular) -> UIFont {
        UIFont(name: "Muli\(style.rawValue)", size: size)!
    }
    
    enum MontserratStyle: String, CaseIterable {
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
    
    static func montserrat(ofSize size: CGFloat, style: MontserratStyle = .regular) -> UIFont {
        UIFont(name: "Montserrat\(style.rawValue)", size: size)!
    }
}


extension UIFont {
    enum Montserrat {
        static var navBarLargeTitle: UIFont {
            .montserrat(ofSize: 30, style: .semiBold)
        }

        static var navBarInlineTitle: UIFont {
            .montserrat(ofSize: 20, style: .semiBold)
        }
    }
}
