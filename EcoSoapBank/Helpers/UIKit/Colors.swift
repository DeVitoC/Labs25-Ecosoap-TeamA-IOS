//
//  Colors.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIColor {
    static let esbGreen = UIColor(named: "ESBGreen")!
    static let downyBlue = UIColor(named: "DownyBlue")!
    static let codGrey = UIColor(named: "CodGrey")!
    static let montanaGrey = UIColor(named: "MontanaGrey")!
    static let shuttleGrey = UIColor(named: "ShuttleGrey")!
    static let silver = UIColor(named: "Silver")!
}

// MARK: - RGBA / HSBA

extension UIColor {
    /// The red, green, blue, and alpha values of the color, scaled between 0 and 1.0.
    var rgba: RGBA {
        var rgba = RGBA(red: 0, green: 0, blue: 0, alpha: 0)
        getRed(&rgba.red, green: &rgba.green, blue: &rgba.blue, alpha: &rgba.alpha)
        return rgba
    }

    /// The hue, saturation, brightness, and alpha values of the color, scaled between 0 and 1.0.
    var hsba: HSBA {
        var hsba = HSBA(hue: 0, saturation: 0, brightness: 0, alpha: 0)
        getHue(&hsba.hue, saturation: &hsba.saturation, brightness: &hsba.brightness, alpha: &hsba.alpha)
        return hsba
    }

    /// Returns color with the same hue/saturation/alpha, but with 1 minus the original brightness.
    var inverseBrightness: UIColor {
        let hsba = self.hsba
        return UIColor(hue: hsba.hue,
                       saturation: hsba.saturation,
                       brightness: 1 - hsba.brightness,
                       alpha: hsba.alpha)
    }

    /// Returns a color with the new brightness and all other components values identical to the original.
    func withBrightness(_ newBrightness: CGFloat) -> UIColor {
        let oldHSBA = self.hsba
        return UIColor(
            hue: oldHSBA.hue,
            saturation: oldHSBA.saturation,
            brightness: newBrightness,
            alpha: oldHSBA.alpha)
    }

    /// Returns a color with the old brightness adjusted by the provided amount and all other components values identical to the original.
    func adjustingBrightness(by brightnessChange: CGFloat) -> UIColor {
        let oldHSBA = self.hsba
        return UIColor(
            hue: oldHSBA.hue,
            saturation: oldHSBA.saturation,
            brightness: oldHSBA.brightness + brightnessChange,
            alpha: oldHSBA.alpha)
    }

    /// Basic `CGFloat` values representative of red/green/blue/alpha color components.
    /// Component values are scaled 0-1.0.
    struct RGBA {
        var red, green, blue, alpha: CGFloat
    }

    /// Basic `CGFloat` values representative of hue/saturation/brightness/alpha color components.
    /// Component values are scaled 0-1.0.
    struct HSBA {
        var hue, saturation, brightness, alpha: CGFloat
    }
}

// MARK: - Interface Style

extension UIColor {
    /// Initializes a dynamic color that evaluates to either the `light` or `dark` colors provided
    /// depending on the current user interface style.
    convenience init(
        light: @escaping @autoclosure () -> UIColor,
        dark: @escaping @autoclosure () -> UIColor
    ) {
        self.init { traits in
            switch traits.userInterfaceStyle {
            case .dark:
                return dark()
            default:
                return light()
            }
        }
    }

    /// Returns `self` if in a non-`.dark` user interface style, or else the provided color.
    /// This is inverted if `defaultLight` is set to `false`; `self` will be used in dark mode and
    /// the provided color otherwise.
    func or(_ otherColor: @escaping @autoclosure () -> UIColor,
            defaultLight: Bool = true
    ) -> UIColor {
        if defaultLight {
            return UIColor(light: self, dark: otherColor())
        } else {
            return UIColor(light: otherColor(), dark: self)
        }
    }

    /// Returns self if in a non-`.dark` user interface style, otherwise returns `self.inverseBrightness`.
    /// This is inverted if `defaultLight` is set to `false`; `self` will be used in dark mode and
    /// the provided color otherwise.
    func orInverse(defaultLight: Bool = true) -> UIColor {
        self.or(self.inverseBrightness, defaultLight: defaultLight)
    }

    func orWithBrightness(
        _ newBrightness: CGFloat,
        defaultLight: Bool = true
    ) -> UIColor {
        self.or(self.withBrightness(newBrightness), defaultLight: defaultLight)
    }

    ///
    func orAdjustingBrightness(
        by brightnessChange: CGFloat,
        defaultLight: Bool = true
    ) -> UIColor {
        self.or(self.adjustingBrightness(by: brightnessChange), defaultLight: defaultLight)
    }
}
