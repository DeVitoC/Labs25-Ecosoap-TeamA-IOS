//
//  EditProfileView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel

    @State var profileInfo: EditableProfileInfo

    @Environment(\.presentationMode) var presentationMode
    @State var labelWidth: CGFloat?

    init(_ user: User) {
        self._profileInfo = State(initialValue: EditableProfileInfo(user: user))
    }

    var body: some View {
        With($profileInfo) { profile in
            Form {
                Section(header: Text("Name".uppercased())) {
                    self.textField("First", text: profile.firstName)
                    self.textField("Middle", text: profile.middleName)
                    self.textField("Last", text: profile.lastName)
                }

                Section(header: Text("Contact Info".uppercased())) {
                    self.textField("Email", text: profile.email)
                    self.textField("Skype", text: profile.skype)
                    self.textField("Phone", text: profile.phone)
                }
            }
        }
        .keyboardAvoiding()
        .navigationBarTitle("Edit Profile")
        .navigationBarItems(trailing: Button(
            action: commitChanges,
            label: { Text("Save") })
            .foregroundColor(.barButtonTintColor)
            .font(.barButtonItem)
        )
    }

    func textField(_ title: String, text: Binding<String>) -> some View {
        LabelAlignedTextField(title: title, labelWidth: $labelWidth, text: text)
            .fonts(label: Font(UIFont.muli(style: .caption1, typeface: .bold)),
                   textField: Font(UIFont.muli(typeface: .light)))
    }

    func commitChanges() {
        viewModel.commitProfileChanges(profileInfo) {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static let user = User.placeholder()
    static var previews: some View {
        NavigationView {
            EditProfileView(user).environmentObject(ProfileViewModel(
                user: user,
                userController: UserController(dataLoader: MockUserDataProvider()),
                delegate: nil))
        }
    }
}
