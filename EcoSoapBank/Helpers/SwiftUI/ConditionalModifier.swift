//
//  ConditionalModifier.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-12.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


extension View {
    @ViewBuilder
    func `if`<ModifiedContent: View>(
        _ condition: Bool,
        then modifiedContent: @escaping (Self) -> ModifiedContent
    ) -> some View {
        if condition {
            modifiedContent(self)
        } else {
            self
        }
    }
}
