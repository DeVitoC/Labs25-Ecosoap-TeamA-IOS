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
    /// The width of the widest label; used for aligning labels in a column.
    @State var labelWidth: CGFloat?

    init(_ user: User) {
        self._profileInfo = State(initialValue: EditableProfileInfo(user: user))
    }

    var body: some View {
        With($profileInfo) { prf in
            Form {
                Section(header: Text("Name".uppercased())) {
                    self.textField("First", text: prf.firstName)
                    self.textField("Middle", text: prf.middleName)
                    self.textField("Last", text: prf.lastName)
                }

                Section(header: Text("Contact Info".uppercased())) {
                    self.textField("Email", text: prf.email)
                    self.textField("Skype", text: prf.skype)
                    self.textField("Phone", text: prf.phone)
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

    /// A custom label and text field, aligned vertically.
    func textField(_ title: String, text: Binding<String>) -> some View {
        LabelAlignedTextField(title: title, labelWidth: $labelWidth, text: text)
            .fonts(label: Font(UIFont.preferredMuli(forTextStyle: .caption1, typeface: .bold)),
                   textField: Font(UIFont.preferredMuli(forTextStyle: .body, typeface: .light)))
    }

    /// Save the user's profile changes to the server.
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
