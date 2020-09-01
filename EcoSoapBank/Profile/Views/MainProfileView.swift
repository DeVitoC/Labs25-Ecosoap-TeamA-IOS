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
                        Text("Edit Profile")
                    }

                    if !viewModel.properties.isEmpty {
                        Picker("Managing:",
                               selection: $viewModel.selectedPropertyIndex
                        ) {
                            ForEach(0..<viewModel.properties.count) { idx in
                                Text(self.viewModel.properties[idx].name)
                            }
                        }
                    }
                }

                Section(header: Text("Edit Property Info".uppercased())) {
                    ForEach(viewModel.user.properties ?? []) { property in
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
