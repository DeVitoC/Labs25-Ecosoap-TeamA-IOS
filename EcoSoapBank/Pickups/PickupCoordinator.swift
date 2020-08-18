//
//  PickupCoordinator.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI
import Combine


class PickupCoordinator: FlowCoordinator {
    private let pickupController: PickupController

    private(set) lazy var rootVC: UIViewController = UIHostingController(
        rootView: PickupsView(pickupController: pickupController))

    private var cancellables = Set<AnyCancellable>()

    init(pickupController: PickupController) {
        self.pickupController = pickupController
        pickupController.pickupScheduleResult
            .handleError(handleError(_:))
            .sink(receiveValue: handlePickupScheduleResult(_:))
            .store(in: &cancellables)
    }

    convenience init() {
        self.init(pickupController:
            PickupController(dataProvider: MockPickupProvider()))
    }

    func start() {
        rootVC.tabBarItem = UITabBarItem(
            title: "Pickups",
            image: UIImage(
                systemName: "cube.box",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 22,
                    weight: .regular)),
            tag: 1)
    }

    private func handleError(_ error: Error) {
        print(error)
        // TODO: handle errors
    }

    private func handlePickupScheduleResult(_ pickupResult: Pickup.ScheduleResult) {
        print(pickupResult)
        // TODO: handle new pickup result
    }
}
