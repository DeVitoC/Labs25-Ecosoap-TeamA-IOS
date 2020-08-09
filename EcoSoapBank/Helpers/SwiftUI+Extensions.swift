//
//  SwiftUI+Extensions.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


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
