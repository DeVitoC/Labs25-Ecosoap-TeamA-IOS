//
//  Alert+ErrorMessage.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-10.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


extension Alert {
    init(_ errorMessage: ErrorMessage,
         primaryButton: Button? = nil,
         secondaryButton: Button? = nil
    ) {
        let title = Text(errorMessage.title)
        let message = Text(errorMessage.message)

        if let primary = primaryButton {
            if let secondary = secondaryButton {
                self.init(title: title,
                          message: message,
                          primaryButton: primary,
                          secondaryButton: secondary)
            } else {
                self.init(title: title, message: message, dismissButton: primary)
            }
        } else {
            self.init(title: title, message: message)
        }
    }

    init(_ error: Error?,
         primaryButton: Button? = nil,
         secondaryButton: Button? = nil
    ) {
        self.init(ErrorMessage(error),
                  primaryButton: primaryButton,
                  secondaryButton: secondaryButton)
    }
}

extension View {
    func errorAlert(_ error: Binding<Error?>) -> some View {
        self.alert(
            isPresented: Binding(
                get: { error.wrappedValue != nil },
                set: { hasError in if !hasError { error.wrappedValue = nil } }),
            content: { Alert(error.wrappedValue) })
    }
}
