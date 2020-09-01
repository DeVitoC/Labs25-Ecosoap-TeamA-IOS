//
//  LabelAlignedTextField.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI

struct LabelAlignedTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    @Binding var labelWidth: CGFloat?

    var labelFont: Font?
    var textFieldFont: Font?

    init(title: String, labelWidth: Binding<CGFloat?>, text: Binding<String>) {
        self.init(title: title, placeholder: title, labelWidth: labelWidth, text: text)
    }

    init(title: String, placeholder: String, labelWidth: Binding<CGFloat?>, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self._labelWidth = labelWidth
        self._text = text
    }

    var body: some View {
        HStack(alignment: .center) {
            label

            if textFieldFont != nil {
                textField.font(textFieldFont!)
            } else {
                textField
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder private var _basicLabel: some View {
        if labelFont != nil {
            Text(title).font(labelFont!)
        } else {
            Text(title)
        }
    }

    private var label: some View {
        _basicLabel
            // Set width of all labels based on width of longest label
            .background(GeometryReader { proxy in
                Color.clear.preference(key: WidthKey.self,
                                       value: proxy.size.width)
            })
            .onPreferenceChange(WidthKey.self, perform: {
                if let new = $0, let old = self.labelWidth {
                    self.labelWidth = max(new, old)
                } else {
                    self.labelWidth = $0
                }
            })
            .frame(width: labelWidth, alignment: .leading)
    }

    private var textField: some View {
        TextField(title, text: $text)
    }
}

// MARK: - Preference Key

extension LabelAlignedTextField {
    struct WidthKey: PreferenceKey {
        static var defaultValue: CGFloat?

        static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
            if let new = nextValue() {
                if let old = value {
                    value = max(old, new)
                } else {
                    value = new
                }
            }
        }
    }
}

// MARK: - Modifiers

extension LabelAlignedTextField {
    func fonts(label: Font? = nil, textField: Font? = nil) -> LabelAlignedTextField {
        configure(self) {
            if let lf = label {
                $0.labelFont = lf
            }
            if let txtf = textField {
                $0.textFieldFont = txtf
            }
        }
    }
}
