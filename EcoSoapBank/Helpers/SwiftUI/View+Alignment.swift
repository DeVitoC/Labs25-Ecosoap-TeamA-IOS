//
//  View+Alignment.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-03.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


extension View {
    /// Reads the provided key path value from a `GeometryReader`'s proxy applied to the view's background
    /// and applies it to the provided preference key, performing the provided closure when the preference changes.
    /// Useful for reading size values, writing them to a size binding, and aligning several views according to this value.
    func readingGeometry<K: PreferenceKey>(
        forKey key: K.Type,
        keyPath: KeyPath<GeometryProxy, K.Value>,
        onChange: @escaping (K.Value) -> Void
    ) -> some View where K.Value: Equatable {
        self.background(GeometryReader { proxy in
            Color.clear
                .preference(key: K.self,
                            value: proxy[keyPath: keyPath])
        }).onPreferenceChange(K.self, perform: { onChange($0) })
    }

    /// Reads the provided key path value from a `GeometryReader`'s proxy applied to the view's background
    /// and applies it to the provided preference key, performing the provided closure when the preference changes.
    /// Useful for reading size values, writing them to a size binding, and aligning several views according to this value.
    func readingGeometry<K: PreferenceKey, V>(
        key: K.Type,
        valuePath: KeyPath<GeometryProxy, V>,
        onChange: @escaping (K.Value) -> Void
    ) -> some View where K.Value == V?, V: Equatable {
        self.background(GeometryReader { proxy in
            Color.clear
                .preference(key: K.self,
                            value: proxy[keyPath: valuePath])
        }).onPreferenceChange(K.self, perform: { onChange($0) })
    }
}
