//
//  ProfileViewModel.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import Combine


class ProfileViewModel: ObservableObject {
    /// The currently signed-in user.
    @Published private(set) var user: User
    /// The selected property to be managed (or all user properties).
    var managingProperty: PropertySelection {
        get { UserDefaults.standard.propertySelection(forUser: user) }
        set { UserDefaults.standard.setSelectedProperty(newValue.property, forUser: user) }
    }
    /// If non-nil, an error that was previously thrown by asynchronous calls. Can be subscribed to via `$error`.
    @Published var error: Error?

    /// Will be set to `true` when making asynchronous calls, and back to `false` when the calls complete.
    @Published private(set) var loading = false
    /// If true, when `savePropertyChanges(_:onSuccess:)` is called, the provided `propertyInfo`'s `billingAddress` will be replaced with the vallue in `shippingAddress`.
    @Published var useShippingAddressForBilling = false

    /// Property options available for selection (ie, the user's properties + `.all`).
    let propertyOptions: [PropertySelection]
    /// Forwarded from `user.properties`.
    var properties: [Property] { user.properties ?? [] }
    /// The provided UserController object.
    let userController: UserController

    /// Forwards calls to log out.
    weak var delegate: ProfileDelegate?

    private var cancellables = Set<AnyCancellable>()

    /// Initializes a new view model and subscribes to changes on the provided user controller's `user` object.
    init(user: User,
         userController: UserController,
         delegate: ProfileDelegate?
    ) {
        self.user = user

        if user.properties?.count ?? 0 > 0 {
            var options: [PropertySelection] = [.all]
            options.append(contentsOf: (user.properties ?? []).map { .select($0) })
            self.propertyOptions = options
        } else {
            self.propertyOptions = []
        }
        self.userController = userController
        self.delegate = delegate
        // TODO: Try removing this, make `user` a 'getter' only, and
        userController.$user
            .dropFirst()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.user, on: self)
            .store(in: &cancellables)
        UserDefaults.standard.selectedPropertyPublisher(forUser: user)
            .sink { [unowned self] _ in self.objectWillChange.send() }
            .store(in: &cancellables)
    }

    /// Commit the provided profile changes. If successful, the updated profile will be saved to the viewModel's `userController`, which will also update the `user` object on the view model.
    /// - Parameters:
    ///   - info: The profile changes to be saved.
    ///   - onSuccess: Called if the save was successful.
    ///
    /// If unsuccessful, the returned error will be set to the view model's `error` property. Subscribe to changes to this via the `$error` publisher.
    func commitProfileChanges(_ profileInfo: EditableProfileInfo, onSuccess: @escaping () -> Void) {
        loading = true

        userController.updateUserProfile(profileInfo) { result in
            DispatchQueue.main.async { [weak self] in
                self?.loading = false

                switch result {
                case .success:
                    onSuccess()
                case .failure(let updateError):
                    self?.error = updateError
                }
            }
        }
    }

    /// Commit the provided property changes. If successful, the updated property will be saved to the viewModel's `userController`, which will also update the `user` object on the controller and on the view model.
    /// - Parameters:
    ///   - info: The property changes to be saved.
    ///   - onSuccess: Called if the save was successful.
    ///
    /// If unsuccessful, the returned error will be set to the view model's `error` property. Subscribe to changes to this via the `$error` publisher.
    func savePropertyChanges(_ info: EditablePropertyInfo, onSuccess: @escaping () -> Void) {
        loading = true

        var submission = info
        if useShippingAddressForBilling {
            submission.billingAddress = submission.shippingAddress
        }
        self.userController.updateProperty(with: submission) { [weak self] result in
            DispatchQueue.main.async {
                self?.loading = false
                
                if case .failure(let error) = result {
                    self?.error = error
                } else {
                    onSuccess()
                }
            }
        }
    }

    /// Log the user out using the user controller and provided `ProfileDelegate`.
    func logOut() {
        userController.logOut()
        delegate?.logOut()
    }
}
