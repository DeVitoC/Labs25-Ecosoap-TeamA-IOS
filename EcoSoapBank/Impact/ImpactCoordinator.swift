//
//  ImpactCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ImpactCoordinator: FlowCoordinator {
    
    init(user: User, dataProvider: ImpactDataProvider) {
        impactVC.impactController = ImpactController(user: user, dataProvider: dataProvider)
    }
    
    let rootVC = UINavigationController()
    let impactVC = ImpactViewController()
    
    func start() {
        let globe = UIImage(
            systemName: "globe",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        )
        rootVC.tabBarItem = UITabBarItem(title: "Impact", image: globe, tag: 0)
        rootVC.pushViewController(impactVC, animated: false)
    }
}
