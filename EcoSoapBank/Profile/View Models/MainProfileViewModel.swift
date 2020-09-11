//
//  MainProfileViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import SwiftUI


class MainProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var editableInfo: EditableProfileInfo
    @Published var selectedProperty: PropertySelection {
        didSet {
            UserDefaults.standard.setSelectedProperty(selectedProperty.property, forUser: user)
        }
    }
    @Published var error: Error?

    @Published var isEditingProperty = false
    @Published private(set) var loading = false

    let propertyOptions: [PropertySelection]
    let properties: [Property]
    let userController: UserController

    private var editingPropertyVM: EditPropertyViewModel?

    weak var delegate: ProfileDelegate?
    
    init(user: User,
         userController: UserController,
         delegate: ProfileDelegate?
    ) {
        self.user = user
        self.editableInfo = EditableProfileInfo(user: user)

        if user.properties?.count ?? 0 > 0 {
            var options: [PropertySelection] = [.all]
            options.append(contentsOf: (user.properties ?? []).map { .select($0) })
            self.propertyOptions = options
        } else {
            self.propertyOptions = []
        }
        self.selectedProperty = UserDefaults.standard.propertySelection(forUser: user)
        self.properties = user.properties ?? []
        self.userController = userController
        self.delegate = delegate
    }

    func editPropertyVM(_ property: Property) -> EditPropertyViewModel {
        editingPropertyVM ??= EditPropertyViewModel(
            property,
            isActive: Binding(
                get: { [weak self] in self?.isEditingProperty == true },
                set: { [weak self] isNowEditing in self?.isEditingProperty = isNowEditing }),
            userController: userController)
    }

    func commitProfileChanges() {
        loading = true

        userController.updateUserProfile(editableInfo) { result in
            DispatchQueue.main.async { [weak self] in
                self?.loading = false

                switch result {
                case .success(let newUser):
                    self?.editableInfo = EditableProfileInfo(user: newUser)
                    self?.user = newUser
                case .failure(let updateError):
                    self?.error = updateError
                }
            }
        }
    }

    func logOut() {
        userController.logOut()
        delegate?.logOut()
    }
}
