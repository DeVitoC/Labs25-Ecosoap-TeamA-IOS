//
//  MainProfileViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import Combine


class MainProfileViewModel: ObservableObject {
    // For strange SwiftUI bug
    static let propertyTypes: [Property.PropertyType] = Property.PropertyType.allCases

    @Published var user: User
    @Published var profileInfo: EditableProfileInfo
    @Published var managingProperty: PropertySelection {
        didSet {
            UserDefaults.standard.setSelectedProperty(managingProperty.property, forUser: user)
        }
    }
    @Published var error: Error?

    @Published var isEditingProfile = false
    @Published private(set) var loading = false
    @Published var useShippingAddressForBilling = false

    let propertyOptions: [PropertySelection]
    var properties: [Property] { user.properties ?? [] }
    let userController: UserController

    weak var delegate: ProfileDelegate?

    private var cancellables = Set<AnyCancellable>()
    
    init(user: User,
         userController: UserController,
         delegate: ProfileDelegate?
    ) {
        self.user = user
        self.profileInfo = EditableProfileInfo(user: user)

        if user.properties?.count ?? 0 > 0 {
            var options: [PropertySelection] = [.all]
            options.append(contentsOf: (user.properties ?? []).map { .select($0) })
            self.propertyOptions = options
        } else {
            self.propertyOptions = []
        }
        self.managingProperty = UserDefaults.standard.propertySelection(forUser: user)
        self.userController = userController
        self.delegate = delegate
        userController.$user
            .dropFirst()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.user, on: self)
            .store(in: &cancellables)
    }

    func commitProfileChanges() {
        loading = true

        userController.updateUserProfile(profileInfo) { result in
            DispatchQueue.main.async { [weak self] in
                self?.loading = false

                switch result {
                case .success(let newUser):
                    self?.profileInfo = EditableProfileInfo(user: newUser)
                case .failure(let updateError):
                    self?.error = updateError
                }
            }
        }
    }

    func savePropertyChanges(_ info: EditablePropertyInfo, completion: @escaping () -> Void) {
        var submission = info
        if useShippingAddressForBilling {
            submission.billingAddress = submission.shippingAddress
        }
        self.userController.updateProperty(with: submission) { [weak self] result in
            DispatchQueue.main.async {
                if case .failure(let error) = result {
                    self?.error = error
                } else {
                    completion()
                }
            }
        }
    }

    func logOut() {
        userController.logOut()
        delegate?.logOut()
    }
}
