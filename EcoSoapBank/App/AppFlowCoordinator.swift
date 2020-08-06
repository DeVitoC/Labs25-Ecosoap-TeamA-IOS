//
//  AppFlowCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-05.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class AppFlowCoordinator: FlowCoordinator {
    let window: UIWindow

    var rootVC: UIViewController

    init(window: UIWindow) {
        self.window = window
        guard let initialVC = UIStoryboard.main.instantiateInitialViewController() else {
            preconditionFailure("Could not instantiate initial view controller from main storyboard")
        }
        rootVC = initialVC
    }

    func start() {
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
    }
}
