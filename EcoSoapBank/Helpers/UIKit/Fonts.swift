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

    /// Returns a Muli font with the provided style, typeface,  and size (or the default size of the provided style if `nil`).
    static func muli(
        ofSize size: CGFloat? = nil,
        style: TextStyle? = nil,
        typeface: MuliTypeface = .regular
    ) -> UIFont {
        UIFont(
            name: .muli + typeface.rawValue,
            size: size ?? UIFontDescriptor
                .preferredFontDescriptor(withTextStyle: style ?? .body).pointSize
        )!.scaled(forStyle: style)
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

    /// Returns a Montserrat font with the provided style, typeface,  and size (or the default size of the provided style if `nil`).
    static func montserrat(
        ofSize size: CGFloat? = nil,
        style: TextStyle? = nil,
        typeface: MontserratTypeface = .regular
    ) -> UIFont {
        UIFont(
            name: .montserrat + typeface.rawValue,
            size: size ?? UIFontDescriptor
                .preferredFontDescriptor(withTextStyle: style ?? .body).pointSize
            )!.scaled(forStyle: style)
    }

    /// Returns a Dynamic Type-adaptive version of the font.
    func scaled(forStyle style: TextStyle? = nil) -> UIFont {
        let metrics: UIFontMetrics = {
            if let style = style {
                return UIFontMetrics(forTextStyle: style)
            } else {
                return .default
            }
        }()
        return metrics.scaledFont(for: self)
    }
    
    static var navBarLargeTitle: UIFont {
        .montserrat(ofSize: 30, typeface: .semiBold)
    }
    
    static var navBarInlineTitle: UIFont {
        .montserrat(ofSize: 22, typeface: .semiBold)
    }
    
    static var barButtonItem: UIFont {
        .muli(typeface: .semiBold)
    }
}


extension String {
    static let montserrat = "Montserrat"
    static let muli = "Muli"
}
