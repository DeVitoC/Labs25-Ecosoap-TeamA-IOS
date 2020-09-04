//
//  MainProfileViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine


class MainProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var editableInfo: EditableProfileInfo
    @Published var selectedProperty: PropertySelection

    let propertyOptions: [PropertySelection]
    let properties: [Property]
    let userController: UserController

    private var editingPropertyVM: EditPropertyViewModel?

    private var cancellables = Set<AnyCancellable>()

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
        self.selectedProperty = propertyOptions.first ?? .none
        self.properties = user.properties ?? []
        self.userController = userController
        self.delegate = delegate
    }

    func editPropertyVM(_ property: Property) -> EditPropertyViewModel {
        editingPropertyVM = EditPropertyViewModel(property)
        return editingPropertyVM!
    }

    func commitProfileChanges() {

    }

    func logOut() {
        userController.logOut()
        delegate?.logOut()
    }
}
