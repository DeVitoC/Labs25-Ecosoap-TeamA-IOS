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
    private var user: User

    private(set) lazy var rootVC: UIViewController = UIHostingController(
        rootView: PickupsView(pickupController: pickupController))
    private lazy var newPickupVC = configure(SchedulePickupViewController(
        viewModel: pickupController.newPickupViewModel)) {
            let cancel = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(cancelNewPickup(_:)))
            cancel.tintColor = UIColor.codGrey
            $0.navigationItem.setLeftBarButton(cancel, animated: false)
            $0.title = "Schedule New Pickup"
    }
    private lazy var newPickupNavController = configure(
        UINavigationController(rootViewController: newPickupVC),
        with: {
            $0.modalPresentationStyle = .fullScreen
    })

    private var cancellables = Set<AnyCancellable>()

    init(user: User, dataProvider: PickupDataProvider) {
        self.user = user
        self.pickupController = PickupController(user: user, dataProvider: dataProvider)

        // subscribe to and respond to model controller messages
        pickupController.editCarton
            .sink(receiveValue: editCarton(_:))
            .store(in: &cancellables)
        pickupController.pickupScheduleResult
            .handleError(handleError(_:))
            .sink(receiveValue: handlePickupScheduleResult(_:))
            .store(in: &cancellables)
        pickupController.presentNewPickup
            .sink(receiveValue: presentNewPickupView)
            .store(in: &cancellables)
    }

    convenience init() {
        self.init(user: .placeholder(), dataProvider: MockPickupProvider())
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

    func provideUser(_ user: User) {
        self.user = user
    }
}

// MARK: - Event handlers

extension PickupCoordinator {
    private func presentNewPickupView() {
        if user.properties?.first == nil {
            rootVC.presentSimpleAlert(
                with: "No properties to schedule pickups for!",
                message: "Please contact us to set up your properties for container pickups.",
                preferredStyle: .alert,
                dismissText: "OK")
        } else {
            rootVC.present(newPickupNavController, animated: true, completion: nil)
        }
    }

    private func editCarton(_ cartonVM: NewCartonViewModel) {
        guard newPickupVC.isViewLoaded else { return }
        let popover = editCartonVC(for: cartonVM)
        popover.popoverPresentationController?.sourceView =
            newPickupVC.sourceViewForCartonEditingPopover()
        newPickupVC.present(popover, animated: true, completion: nil)
    }

    @objc private func cancelNewPickup(_ sender: Any) {
        rootVC.dismiss(animated: true, completion: nil)
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
                    pickupResult.labelURL!,
                    options: [:],
                    completionHandler: nil)
        }))
        return alert
    }
}

extension PickupCoordinator {
    private func editCartonVC(for viewModel: NewCartonViewModel) -> EditCartonViewController {
        configure(EditCartonViewController(viewModel: viewModel)) {
            $0.modalPresentationStyle = .popover
            $0.popoverPresentationController?.delegate = newPickupVC
            $0.preferredContentSize = CGSize(width: 300, height: 250)
        }
    }
}
