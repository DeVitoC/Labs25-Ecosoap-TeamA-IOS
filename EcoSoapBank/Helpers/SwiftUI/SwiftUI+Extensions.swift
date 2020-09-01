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
    static func notes() -> Image { Image(systemName: "doc.plaintext") }
    static func personSquareFill() -> Image { Image(systemName: "person.crop.square.fill") }
    static func property() -> Image { Image(systemName: "bed.double.fill") }
}

// MARK: - Text

extension Text {
    static func += (lhs: inout Text, rhs: Text) {
        lhs = lhs + rhs
    }

    func font(_ uiFont: UIFont) -> Text {
        font(Font(uiFont))
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

extension View {
    func font(_ uiFont: UIFont) -> some View {
        font(Font(uiFont))
    }
}

// MARK: - Binding

extension Binding {
    /// Initializes a `Binding` that simply returns the provided value non-dynamically.
    /// The binding's setter does nothing.
    ///
    /// Useful for preview/test purposes.
    /// - Parameter getValue: The value to be returned from the getter.
    init(getValue: Value) {
        self.init(get: { getValue }, set: { _ in })
    }
}

// Combines two `Bool`s using the associated operator in the getter
// Setter sets both to the same value for both `&&` and `||`
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
