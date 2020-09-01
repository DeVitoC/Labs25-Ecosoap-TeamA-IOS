//
//  MainProfileView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct MainProfileView: View {
    @ObservedObject var viewModel: MainProfileViewModel

    @State var iconWidth: CGFloat?

    init(viewModel: MainProfileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User".uppercased())) {
                    NavigationLink(destination: EditProfileView(
                        viewModel: EditProfileViewModel(user: viewModel.user))
                    ) {
                        HStack {
                            Image.personSquareFill()
                                .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.1))
                                .background(GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: IconWidth.self,
                                                    value: proxy.size.width)
                                }).onPreferenceChange(IconWidth.self) {
                                    self.iconWidth = $0
                            }

                            Text("Edit Profile")
                        }
                    }

                    if !viewModel.propertyOptions.isEmpty {
                        Picker(
                            selection: $viewModel.selectedPropertyIndex,
                            label: HStack {
                                Image.property()
                                    .resizable()
                                    .padding(2)
                                    .background(
                                        Color.green.clipShape(
                                            RoundedRectangle(
                                                cornerRadius: 3,
                                                style: .circular)
                                        ).aspectRatio(CGSize(width: 1, height: 1),
                                                      contentMode: .fit))
                                    .foregroundColor(.white)
                                    .frame(width: iconWidth, height: iconWidth)
                                Text("Current Property")
                            }
                        ) {
                            ForEach(0 ..< viewModel.propertyOptions.count) { idx in
                                Text(self.viewModel.propertyOptions[idx].display)
                            }
                        }
                    }
                }

                Section(header: Text("Edit Property Info".uppercased())) {
                    ForEach(viewModel.properties) { property in
                        NavigationLink(
                            destination: EditPropertyView(
                                viewModel: EditPropertyViewModel(property))
                        ) {
                            Text(property.name)
                        }
                    }
                }
            }.navigationBarTitle("Profile Settings", displayMode: .inline)
        }.font(.muli())
    }
}

struct IconWidth: PreferenceKey {
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

struct MainProfileView_Previews: PreviewProvider {
    static let user: User = .placeholder()

    static var previews: some View {
        MainProfileView(
            viewModel: MainProfileViewModel(
                user: .placeholder(),
                currentProperty: .random(),
                userController: UserController(dataLoader: MockLoginProvider()))
        )
    }
}
