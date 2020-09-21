//
//  SwiftUI+Extensions.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

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

// MARK: - Color

extension Color {
    static var barButtonTintColor: Color {
        Color(.barButtonTint)
    }
}

// MARK: - Text

extension Text {
    func font(_ uiFont: UIFont) -> Text {
        font(Font(uiFont))
    }
}

extension View {
    func font(_ uiFont: UIFont) -> some View {
        font(Font(uiFont))
    }
}
