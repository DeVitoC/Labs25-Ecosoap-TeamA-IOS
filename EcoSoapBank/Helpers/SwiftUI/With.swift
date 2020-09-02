//
//  With.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-01.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


/// Acts as a "shortcut" if you use a deeply nested item in several spots in a view hierarchy.
struct With<T, Content: View>: View {
    var item: T
    var content: (T) -> Content

    init(_ item: T, @ViewBuilder _ content: @escaping (T) -> Content) {
        self.item = item
        self.content = content
    }

    var body: some View {
        content(item)
    }
}
