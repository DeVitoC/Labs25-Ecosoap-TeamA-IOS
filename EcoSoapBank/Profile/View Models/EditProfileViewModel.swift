//
//  EditProfileViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


class EditProfileViewModel: ObservableObject {
    @Published var editableInfo: EditableProfileInfo
    let user: User

    init(user: User) {
        self.editableInfo = EditableProfileInfo(user: user)
        self.user = user
    }

    func commitChanges() {
        
    }
}

struct EditableProfileInfo: Encodable {
    let id: String
    var firstName: String
    var middleName: String
    var lastName: String
    var email: String
    var skype: String
    var phone: String

    init(user: User) {
        self.id = user.id
        self.firstName = user.firstName
        self.middleName = user.middleName ?? ""
        self.lastName = user.lastName
        self.email = user.email
        self.skype = user.skype ?? ""
        self.phone = user.phone ?? ""
    }
}
