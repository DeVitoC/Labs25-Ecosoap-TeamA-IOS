//
//  SwiftUI+Extensions.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
// swiftlint:disable shorthand_operator

import SwiftUI
import UIKit
import Combine


// MARK: - Image

extension Image {
    static func plus() -> Image { Image(systemName: "plus") }
    static func cubeBox() -> Image { Image(systemName: "cube.box") }
}


// MARK: - Text

extension Text {
    static func += (lhs: inout Text, rhs: Text) {
        lhs = lhs + rhs
    }
}


extension String {
    func uiText() -> Text { Text(self) }
}


extension Array where Element == String {
    func uiText(separatedBy separator: String = "") -> Text {
        self.reduce(into: "") { out, str in
            if out.isEmpty {
                out += str
            } else {
                out += separator + str
            }
        }.uiText()
    }
}

// MARK: - Binding

extension Binding {
    /// Initializes a `Binding` that simply returns the provided value non-dynamically.
    /// The binding's setter does nothing.
    /// - Parameter getValue: The value to be returned from the getter.
    init(getValue: Value) {
        self.init(get: { getValue }, set: { _ in })
    }
}

extension Binding where Value == Bool {
    static func && (lhs: Binding<Bool>, rhs: Binding<Bool>) -> Binding<Bool> {
        Binding<Bool>(
            get: { lhs.wrappedValue && rhs.wrappedValue },
            set: {
                lhs.wrappedValue = $0
                rhs.wrappedValue = $0
        })
    }

    static func || (lhs: Binding<Bool>, rhs: Binding<Bool>) -> Binding<Bool> {
        Binding<Bool>(
            get: { lhs.wrappedValue || rhs.wrappedValue },
            set: {
                lhs.wrappedValue = $0
                rhs.wrappedValue = $0
        })
    }
}
