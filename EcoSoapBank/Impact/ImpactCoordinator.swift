//
//  ImpactCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class ImpactCoordinator: FlowCoordinator {
    var rootVC = ImpactViewController()
    
    func start() {
        rootVC.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
    }
}
