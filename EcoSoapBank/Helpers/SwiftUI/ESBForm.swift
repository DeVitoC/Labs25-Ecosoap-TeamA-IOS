//
//  ESBForm.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct ESBForm: View {
    let formTitle: String
    let navItem: Button<Text>
    let sections: [SectionInfo]

    @State var labelWidth: CGFloat?

    init(title: String, navItem: Button<Text>, sections: [SectionInfo]) {
        self.formTitle = title
        self.sections = sections
        self.navItem = navItem
    }

    func sectionTextField(_ title: String, text: Binding<String>) -> some View {
        HStack(alignment: .center) {
            Text(title + ":")
                .font(.muli(style: .caption1, typeface: .bold))
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
                .padding(.trailing, 8)
            TextField(title, text: text).font(.muli(typeface: .light))
        }
    }

    var body: some View {
        Form {
            ForEach(sections) { sectionInfo in
                Section(header: Text(sectionInfo.title.uppercased())) {
                    ForEach(sectionInfo.fields) {
                        self.sectionTextField($0.title, text: $0.text)
                    }
                }
            }
        }
        .navigationBarTitle(Text(formTitle), displayMode: .inline)
        .navigationBarItems(trailing: navItem)
    }
}

// MARK: - Helper Types

extension ESBForm {
    struct SectionInfo: Identifiable, Hashable {
        let title: String
        let fields: [EditableText]

        var id: SectionInfo { self }
    }

    struct EditableText: Identifiable, Hashable {
        let title: String
        let text: Binding<String>

        var id: String { title }

        static func == (lhs: ESBForm.EditableText, rhs: ESBForm.EditableText) -> Bool {
            lhs.title == rhs.title
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
    }

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
