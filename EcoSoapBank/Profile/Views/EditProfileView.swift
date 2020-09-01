//
//  EditProfileView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: EditProfileViewModel

    var body: some View {
        ESBForm(
            title: "Edit Profile",
            navItem: Button(
                action: viewModel.commitProfileUpdates,
                label: { Text("Save") }),
            sections: [
                .init(title: "Name", fields: [
                    .init(title: "First", text: $viewModel.editableInfo.firstName),
                    .init(title: "Middle", text: $viewModel.editableInfo.middleName),
                    .init(title: "Last", text: $viewModel.editableInfo.lastName),
                ]),
                .init(title: "Contact Info", fields: [
                    .init(title: "Email", text: $viewModel.editableInfo.email),
                    .init(title: "Skype", text: $viewModel.editableInfo.skype),
                    .init(title: "Phone", text: $viewModel.editableInfo.phone),
                ])
        ])
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProfileView(viewModel: EditProfileViewModel(user: .placeholder()))
        }
    }
}
