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
    lazy var rootVC: UIViewController = {
        if let vm = profileVM {
            return UIHostingController(rootView: MainProfileView(viewModel: vm))
        } else {
            return UIHostingController(rootView: EmptyView()) // TODO: display error alert
        }
    }()

    private(set) var profileVM: MainProfileViewModel?

    private var userController: UserController

    private var cancellables = Set<AnyCancellable>()

    init(userController: UserController) {
        self.userController = userController

        userController.$user
            .combineLatest(userController.$viewingProperty)
            .sink { [unowned self] info in
                guard let user = info.0, let property = info.1 else {
                    self.profileVM = nil
                    return
                }
                self.profileVM = MainProfileViewModel(
                        user: user,
                        currentProperty: property,
                        userController: userController)
        }.store(in: &cancellables)
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
