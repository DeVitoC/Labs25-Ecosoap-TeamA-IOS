//
//  TextView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-10.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


/// A UIKit `UITextView` wrapped for use in SwiftUI.
struct TextView: UIViewRepresentable {
    @Binding var text: String

    var font: UIFont

    /// Create a `TextView` with a binding to the view's text content and a `UIFont`.
    init(
        text: Binding<String>,
        font: UIFont = .preferredFont(forTextStyle: .body)
    ) {
        self.font = font
        self._text = text
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.delegate = context.coordinator
        textView.font = font
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = font
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>

        init(_ text: Binding<String>) {
            self.text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
}
