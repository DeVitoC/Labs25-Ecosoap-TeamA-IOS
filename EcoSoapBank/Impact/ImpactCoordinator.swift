//
//  ImpactCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ImpactCoordinator: FlowCoordinator {
    private(set) lazy var rootVC = configure(UINavigationController()) {
        $0.navigationBar.prefersLargeTitles = true
        $0.navigationBar.layoutMargins.left = 22
        $0.navigationBar.backgroundColor = .clear
    }
    
    func start() {
        let globe = UIImage(
            systemName: "globe",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        )
        rootVC.tabBarItem = UITabBarItem(title: "Impact", image: globe, tag: 0)
        
        rootVC.pushViewController(ImpactViewController(), animated: false)
    }
}
