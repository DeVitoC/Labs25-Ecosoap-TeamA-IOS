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
    let propertyOptions: [PropertySelection]
    @Published var selectedPropertyIndex: Int
    let userController: UserController

    var selectedProperty: PropertySelection { propertyOptions[selectedPropertyIndex] }
    var properties: [Property] {
        propertyOptions.compactMap { $0.property }
    }

    private var cancellables = Set<AnyCancellable>()
    
    init(user: User, currentProperty: Property, userController: UserController) {
        self.user = user
        self.propertyOptions = [.all] + (user.properties ?? []).map { .select($0) }
        self.selectedPropertyIndex = 0
        self.userController = userController
    }

    func logOut() {
        
    }
}
