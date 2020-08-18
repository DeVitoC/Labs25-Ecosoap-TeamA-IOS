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
        pickupController.presentNewPickup
            .sink(receiveValue: presentNewPickupView)
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
}

// MARK: - Event handlers

extension PickupCoordinator {
    private func presentNewPickupView() {
        rootVC.present(
            configure(NewPickupViewController(
                viewModel: pickupController.newPickupViewModel), with: {
                    $0.modalPresentationStyle = .fullScreen
            }),
            animated: true,
            completion: nil)
    }

    private func handleError(_ error: Error) {
        print(error)
        // TODO: handle errors
    }

    private func handlePickupScheduleResult(_ pickupResult: Pickup.ScheduleResult) {
        let alert = successAlert(for: pickupResult)
        rootVC.dismiss(animated: true) { [weak rootVC] in
            rootVC?.present(alert, animated: true, completion: nil)
        }
    }

    private func successAlert(for pickupResult: Pickup.ScheduleResult) -> UIAlertController {
        let alert = UIAlertController(
            title: "Success!",
            message: "Your pickup has been scheduled. You may now view/print your shipping label.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Later",
            style: .default,
            handler: nil))
        alert.addAction(UIAlertAction(
            title: "View Shipping Label",
            style: .default,
            handler: { _ in
                UIApplication.shared.open(
                    pickupResult.labelURL,
                    options: [:],
                    completionHandler: nil)
        }))
        return alert
    }
}
