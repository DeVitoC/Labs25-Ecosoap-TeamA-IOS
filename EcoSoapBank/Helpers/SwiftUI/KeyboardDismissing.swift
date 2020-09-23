//
//  KeyboardDismissing.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-12.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import Combine


struct KeyboardDismissing: ViewModifier {
    private class KeyboardObserver: ObservableObject {
        @Published var isShowing: Bool

        private let keyboardDidShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardDidShowNotification)
            .map { _ in true }
        private let keyboardDidHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardDidHideNotification)
            .map { _ in false }
        private var keyboardVisibleSink: AnyCancellable?

        init() {
            self.isShowing = false
            keyboardVisibleSink = keyboardDidShow
                .merge(with: keyboardDidHide)
                .assign(to: \.isShowing, on: self)
        }
    }

    @ObservedObject private var keyboardObserver = KeyboardObserver()

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .gesture(TapGesture().onEnded(hideKeyboard),
                     including: keyboardObserver.isShowing ? .all : .none)
    }

    /// Dismisses the keyboard.
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil)
    }
}

extension View {
    /// Enables dismissing the keyborad by tapping anywhere in the view.
    func keyboardDismissing() -> some View {
        modifier(KeyboardDismissing())
    }
}
