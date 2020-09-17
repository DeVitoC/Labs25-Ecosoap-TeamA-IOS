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


protocol ProfileDelegate: AnyObject {
    func logOut()
}

/// Coordinator that initializes and starts the ProfileViewModel
class ProfileCoordinator: FlowCoordinator {

    // rootVC is the base controller that will be opened.
    // In this case, the UIHostingController that will allow SwiftUI views to be displayed on the ViewController
    lazy var rootVC: UIViewController = UIHostingController(rootView: MainProfileView()
        .environmentObject(profileVM))

    // The main ProfileViewModel to be displayed
    private(set) lazy var profileVM: ProfileViewModel = ProfileViewModel(
        user: user,
        userController: userController,
        delegate: delegate)

    private var user: User
    private var userController: UserController

    weak var delegate: ProfileDelegate?

    private var cancellables = Set<AnyCancellable>()


    /// Initializer that takes in a **User**, **UserController**, and optional **ProfileDelegate** and initializes the **ProfileCoordinator**
    /// - Parameters:
    ///   - user: A **User** object that will provide the information for the **ProfileViewModel**
    ///   - userController: The **UserController** to manage the **User** object
    ///   - delegate: Optional **ProfileDelegate** object to handle logging out
    init(user: User,
         userController: UserController,
         delegate: ProfileDelegate?
    ) {
        self.user = user
        self.userController = userController
        self.delegate = delegate
    }

    /// Starts the rootVC as the current VC. Initialized with a "person.circle" image for the tab
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
