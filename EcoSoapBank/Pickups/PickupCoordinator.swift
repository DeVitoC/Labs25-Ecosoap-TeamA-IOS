//
//  PickupCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI


class PickupCoordinator: FlowCoordinator {
    let pickupController = PickupController(dataProvider: MockPickupProvider())

    private(set) lazy var rootVC: UIViewController = UIHostingController(
        rootView: PickupsView(
            pickupController: pickupController,
            delegate: self))

    func start() {
        rootVC.tabBarItem = UITabBarItem(
            tabBarSystemItem: .history,
            tag: 1)
    }
}

extension PickupCoordinator: PickupsViewDelegate {
    func logOut() {
        preconditionFailure("Requested log out (not yet implemented)")
    }
}
