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
        rootView: PickupsView(pickupController: pickupController))

    func start() {
        rootVC.tabBarItem = UITabBarItem(
            tabBarSystemItem: .history,
            tag: 1)
    }
}
