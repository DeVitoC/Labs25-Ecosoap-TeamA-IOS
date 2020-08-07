//
//  PickupCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class PickupCoordinator: FlowCoordinator {
    var rootVC = PickupHistoryViewController()

    func start() {
        rootVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
    }
}
