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

    @State var labelWidth: CGFloat?

    var body: some View {
        With($viewModel.editableInfo) { profile in
            Form {
                Section(header: Text("Name".uppercased())) {
                    self.textField(title: "First", text: profile.firstName)
                    self.textField(title: "Middle", text: profile.middleName)
                    self.textField(title: "Last", text: profile.lastName)
                }

                Section(header: Text("Contact Info".uppercased())) {
                    self.textField(title: "Email", text: profile.email)
                    self.textField(title: "Skype", text: profile.skype)
                    self.textField(title: "Phone", text: profile.phone)
                }
            }
        }.navigationBarTitle("Edit Profile")
    }

    func textField(title: String, text: Binding<String>) -> some View {
        LabelAlignedTextField(title: title, labelWidth: $labelWidth, text: text)
            .fonts(label: Font(UIFont.muli(style: .caption1, typeface: .bold)),
                   textField: Font(UIFont.muli(typeface: .light)))
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProfileView(viewModel: EditProfileViewModel(user: .placeholder()))
        }
    }
}
