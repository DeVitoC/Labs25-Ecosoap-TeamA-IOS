//
//  KeyboardAvoiding.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-12.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import Combine


/// Sets the view to adjust its content based on the keyboard appearing or disappearing.
public struct KeyboardAvoiding: ViewModifier {
    @State var currentHeight: CGFloat = 0

    public func body(content: Content) -> some View {
        content
            .padding(.bottom, currentHeight)
            .edgesIgnoringSafeArea(currentHeight == 0 ? Edge.Set() : .bottom)
            .onAppear(perform: subscribeToKeyboardEvents)
    }

    private let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero }
        .map { $0.height }

    private let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero }

    private func subscribeToKeyboardEvents() {
        _ = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.currentHeight, on: self)
    }
}

extension View {
    /// Sets the view to adjust its content based on the keyboard appearing or disappearing.
    func keyboardAvoiding() -> some View {
        self.modifier(KeyboardAvoiding())
    }


}
