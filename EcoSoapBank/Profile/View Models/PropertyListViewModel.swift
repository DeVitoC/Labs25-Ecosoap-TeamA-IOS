//
//  PropertyListViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


class PropertyListViewModel: ObservableObject {
    @Published var properties: [EditPropertyViewModel]
    let user: User

    init(user: User) {
        self.user = user
        self.properties = user.properties?.map(EditPropertyViewModel.init) ?? []
    }
}
