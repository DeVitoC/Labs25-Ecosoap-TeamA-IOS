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
        With($viewModel.editableInfo) { prof in
            Form {
                Section(header: Text("Name")) {
                    LabelAlignedTextField(title: "First",
                                          labelWidth: self.$labelWidth,
                                          text: prof.firstName)
                    LabelAlignedTextField(title: "Middle",
                                          labelWidth: self.$labelWidth,
                                          text: prof.middleName)
                    LabelAlignedTextField(title: "Last",
                                          labelWidth: self.$labelWidth,
                                          text: prof.lastName)
                }

                Section(header: Text("Contact Info")) {
                    LabelAlignedTextField(title: "Email",
                                          labelWidth: self.$labelWidth,
                                          text: prof.email)
                    LabelAlignedTextField(title: "Skype",
                                          labelWidth: self.$labelWidth,
                                          text: prof.skype)
                    LabelAlignedTextField(title: "Phone",
                                          labelWidth: self.$labelWidth,
                                          text: prof.phone)
                }
            }
        }
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProfileView(viewModel: EditProfileViewModel(user: .placeholder()))
        }
    }
}
