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
    let propertyOptions: [PropertySelection]
    let properties: [Property]
    @Published var selectedPropertyIndex: Int?
    let userController: UserController
    private var editingPropertyVM: EditPropertyViewModel?

    var selectedProperty: PropertySelection? {
        if let idx = selectedPropertyIndex {
            return propertyOptions[idx]
        } else { return nil }
    }

    private var cancellables = Set<AnyCancellable>()
    
    init(user: User, userController: UserController) {
        self.user = user
        self.editableInfo = EditableProfileInfo(user: user)
        var options: [PropertySelection] = [.all]
        options.append(contentsOf: (user.properties ?? []).map { .select($0) })
        self.propertyOptions = options
        self.properties = propertyOptions.compactMap { $0.property }
        self.selectedPropertyIndex = 0
        self.userController = userController
    }

    func editPropertyVM(_ property: Property) -> EditPropertyViewModel {
        editingPropertyVM = EditPropertyViewModel(property)
        return editingPropertyVM!
    }

    func commitProfileChanges() {

    }

    func logOut() {
        
    }
}
