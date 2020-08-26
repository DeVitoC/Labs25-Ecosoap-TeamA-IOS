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

    internal lazy var schedulePickupVM = SchedulePickupViewModel(user: user, delegate: self)

    private(set) lazy var rootVC: UIViewController = UIHostingController(
        rootView: PickupsView(
            pickupController: pickupController,
            schedulePickup: { [weak self] in self?.scheduleNewPickup() }))
    private lazy var newPickupVC = configure(SchedulePickupViewController(viewModel: schedulePickupVM)) {
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
        self.pickupController = PickupController(
            user: user,
            dataProvider: dataProvider)

        // subscribe to and respond to model controller messages
        pickupController.fetchAllPickups()
            .receive(on: DispatchQueue.main)
            .handleError(handleError(_:))
            .sink { _ in }
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
}

// MARK: - Event handlers

extension PickupCoordinator {
    private func presentNewPickupView() {
        guard user.properties?.first != nil else {
            return handleError(PickupError.noProperties)
        }
        rootVC.present(newPickupNavController, animated: true, completion: nil)
    }

    @objc private func cancelNewPickup(_ sender: Any) {
        rootVC.dismiss(animated: true, completion: nil)
    }

    private func handleError(_ error: Error) {
        let title: String
        let message: String

        switch error {
        case .noProperties as PickupError:
            title = "No properties to schedule pickups for!"
            message = "Please contact us to set up your properties for container pickups."
        default:
            // TODO: handle more errors
            title = "An unknown error occurred"
            message = ""
        }

        rootVC.presentSimpleAlert(
            with: title,
            message: message,
            preferredStyle: .alert,
            dismissText: "OK")
    }

    private func handlePickupScheduleResult(_ pickupResult: Pickup.ScheduleResult) {
        schedulePickupVM = SchedulePickupViewModel(user: user, delegate: self)
        let alert = successAlert(for: pickupResult)
        rootVC.dismiss(animated: true) { [unowned rootVC] in
            rootVC.present(alert, animated: true, completion: nil)
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

    private func editCartonVC(for viewModel: NewCartonViewModel) -> EditCartonViewController {
        configure(EditCartonViewController(viewModel: viewModel)) {
            $0.modalPresentationStyle = .popover
            $0.popoverPresentationController?.delegate = newPickupVC
            $0.preferredContentSize = CGSize(width: 300, height: 250)
        }
    }
}

// MARK: - Delegate conformance

extension PickupCoordinator: SchedulePickupViewModelDelegate {
    func schedulePickup(
        for input: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>
    ) {
        pickupController.schedulePickup(for: input)
            .receive(on: DispatchQueue.main)
            .handleError({ [weak self] error in
                self?.handleError(error)
                completion(.failure(error))
            }).sink(receiveValue: { [weak self] result in
                self?.handlePickupScheduleResult(result)
                completion(.success(result))
            }).store(in: &cancellables)
    }

    func editCarton(for cartonVM: NewCartonViewModel) {
        guard newPickupVC.isViewLoaded else { return }
        let popover = editCartonVC(for: cartonVM)
        popover.popoverPresentationController?.sourceView =
            newPickupVC.sourceViewForCartonEditingPopover()
        newPickupVC.present(popover, animated: true, completion: nil)
    }
}

extension PickupCoordinator: PickupsViewDelegate {
    func scheduleNewPickup() {
        presentNewPickupView()
    }
}
