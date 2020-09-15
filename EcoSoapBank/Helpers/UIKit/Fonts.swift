//
//  Fonts.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIFont {
    
    // MARK: - Montserrat
    
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
    
    /// Creates a Dynamic Type font for a given TextStyle with either a specified typeface,
    /// or the default TypeFace for that TextStyle.
    /// - Parameters:
    ///   - textStyle: The desired TextStyle
    ///   - typeface: The desired Typeface. If no Typeface is provided, an appropriate default for the TextStyle is provided.
    /// - Returns: A scaled, Dynamic Type Font that adopts the current font metrics.
    static func preferredMontserrat(forTextStyle textStyle: TextStyle, typeface: MontserratTypeface? = nil) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: textStyle)
        
        if let typeface = typeface {
            return metrics.scaledFont(for: montserrat(ofSize: textStyle.defaultPointSize, typeface: typeface))
        } else {
            let typeface: MontserratTypeface
            
            switch textStyle {
            case .largeTitle, .title1, .title2, .title3, .headline:
                typeface = .semiBold
            default:
                typeface = .regular
            }
            
            return metrics.scaledFont(for: montserrat(ofSize: textStyle.defaultPointSize, typeface: typeface))
        }
    }
    
    /// Creates a static sized font of a ceratin point size and Typeface.
    /// To obtain a Dynamic Type version of the returned font, use UIFontMetrics.
    /// - Parameters:
    ///   - size: The desired font size in points.
    ///   - typeface: The desired Typeface (defaults to .regular)
    /// - Returns: A statically sized font that does not respect the current font metrics.
    static func montserrat(ofSize size: CGFloat, typeface: MontserratTypeface = .regular) -> UIFont {
        UIFont(name: .montserrat + typeface.rawValue, size: size)!
    }
    
    // MARK: - Muli
    
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
    
    
    /// Creates a Dynamic Type font for a given TextStyle with either a specified typeface,
    /// or the default TypeFace for that TextStyle.
    /// - Parameters:
    ///   - textStyle: The desired TextStyle
    ///   - typeface: The desired Typeface. If no Typeface is provided, an appropriate default for the TextStyle is provided.
    /// - Returns: A scaled, Dynamic Type Font that adopts the current font metrics.
    static func preferredMuli(forTextStyle textStyle: TextStyle, typeface: MuliTypeface? = nil) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: textStyle)
        
        if let typeface = typeface {
            return metrics.scaledFont(for: muli(ofSize: textStyle.defaultPointSize, typeface: typeface))
        } else {
            let typeface: MuliTypeface
            
            switch textStyle {
            case.headline:
                typeface = .bold
            case .largeTitle, .title1, .title2, .title3:
                typeface = .semiBold
            default:
                typeface = .regular
            }
            
            return metrics.scaledFont(for: muli(ofSize: textStyle.defaultPointSize, typeface: typeface))
        }
    }
    
    /// Creates a static sized font of a ceratin point size and Typeface.
    /// To obtain a Dynamic Type version of the returned font, use UIFontMetrics.
    /// - Parameters:
    ///   - size: The desired font size in points.
    ///   - typeface: The desired Typeface (defaults to .regular)
    /// - Returns: A statically sized font that does not respect the current font metrics.
    static func muli(ofSize size: CGFloat, typeface: MuliTypeface = .regular) -> UIFont {
        UIFont(name: .muli + typeface.rawValue, size: size)!
    }
    
    // MARK: - General Helpers
    
    func scaled() -> UIFont {
        UIFontMetrics.default.scaledFont(for: self)
    }
    
    // MARK: - Presets
    
    static var navBarLargeTitle: UIFont {
        .preferredMontserrat(forTextStyle: .largeTitle)
    }
    
    static var navBarInlineTitle: UIFont {
        .preferredMontserrat(forTextStyle: .title2)
    }
    
    static var barButtonItem: UIFont {
        .muli(ofSize: 17, typeface: .semiBold)
    }
}

extension UIFont.TextStyle {
    var defaultPointSize: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title1:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption1:
            return 12
        case .caption2:
            return 11
        default:
            return 17
        }
    }
}

fileprivate extension String {
    static let montserrat = "Montserrat"
    static let muli = "Muli"
}
