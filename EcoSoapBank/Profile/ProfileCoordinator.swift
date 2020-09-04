//
//  ProfileCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI
import Combine


class ProfileCoordinator: FlowCoordinator {
    lazy var rootVC = UIHostingController(
        rootView: MainProfileView(viewModel: profileVM))

    private(set) var profileVM: MainProfileViewModel

    private var userController: UserController

    private var cancellables = Set<AnyCancellable>()

    init(user: User, userController: UserController) {
        self.userController = userController
        self.profileVM = MainProfileViewModel(
            user: user,
            userController: userController)
    }

    func start() {
        rootVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(
                systemName: "person.circle",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 22,
                    weight: .regular)),
            tag: 4)
    }
}
