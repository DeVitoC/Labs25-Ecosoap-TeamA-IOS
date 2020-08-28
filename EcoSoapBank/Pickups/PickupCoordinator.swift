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
    private(set) var user: User

    private(set) lazy var rootVC: UIViewController = UIHostingController(
        rootView: PickupsView(
            pickupController: pickupController,
            schedulePickup: { [weak self] in self?.scheduleNewPickup() }))

    private var cancellables = Set<AnyCancellable>()
    private var scheduleVC: SchedulePickupViewController?
    private var scheduleVM: SchedulePickupViewModel?

    init(user: User, dataProvider: PickupDataProvider) {
        self.user = user
        self.pickupController = PickupController(
            user: user,
            dataProvider: dataProvider)

        // subscribe to and respond to model controller messages
        pickupController.fetchPickupsForAllProperties()
            .receive(on: DispatchQueue.main)
            .handleError(handleError(_:))
            .sink { _ in }
            .store(in: &cancellables)
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
    @objc func cancelNewPickup(_ sender: Any? = nil) {
        guard let nav = rootVC.presentedViewController as? UINavigationController,
            nav.viewControllers.first as? SchedulePickupViewController != nil
            else { return }
        rootVC.dismiss(animated: true, completion: sender as? () -> Void)
    }

    func scheduleNewPickup() {
        guard user.properties?.first != nil else {
            return handleError(UserError.noProperties)
        }
        // see `UtilityFunctions.swift` `Optional` extension and infix operator
        let viewController = scheduleVC ??= newScheduleVC()
        let nav = configure(UINavigationController(rootViewController: viewController)) {
            $0.modalPresentationStyle = .fullScreen
        }
        rootVC.present(nav, animated: true, completion: nil)
    }

    private func handleError(_ error: Error) {
        let title: String
        let message: String

        switch error {
        case .noProperties as UserError:
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
        let alert = successAlert(for: pickupResult)
        rootVC.dismiss(animated: true) { [unowned rootVC] in
            rootVC.present(alert, animated: true, completion: { [unowned self] in
                self.scheduleVC = nil
                self.scheduleVM = nil
            })
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
            $0.popoverPresentationController?.delegate = scheduleVC
            $0.preferredContentSize = CGSize(width: 300, height: 250)
        }
    }

    private func newScheduleVC() -> SchedulePickupViewController {
        // see `UtilityFunctions.swift` `Optional` extension and infix operator
        let viewModel = scheduleVM ??= SchedulePickupViewModel(user: user, delegate: self)
        return configure(SchedulePickupViewController(viewModel: viewModel)) {
            let cancel = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(cancelNewPickup(_:)))
            cancel.tintColor = UIColor.codGrey
            $0.navigationItem.setLeftBarButton(cancel, animated: false)
            $0.title = "Schedule New Pickup"
        }
    }
}

// MARK: - Delegate conformance

extension PickupCoordinator: SchedulePickupViewModelDelegate {
    func schedulePickup(
        for input: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>
    ) {
        rootVC.presentedViewController?.present(
            LoadingViewController(loadingText: "Scheduling pickup..."),
            animated: true
        ) {
            self.pickupController.schedulePickup(for: input)
                .receive(on: DispatchQueue.main)
                .handleError({ [weak self] error in
                    self?.handleError(error)
                    completion(.failure(error))
                }).sink(receiveValue: { [weak self] result in
                    self?.handlePickupScheduleResult(result)
                    completion(.success(result))
                }).store(in: &self.cancellables)
        }
    }

    func editCarton(for cartonVM: NewCartonViewModel) {
        guard scheduleVC?.isViewLoaded == true else { return }
        let popover = editCartonVC(for: cartonVM)
        popover.popoverPresentationController?.sourceView =
            scheduleVC?.sourceViewForCartonEditingPopover()
        scheduleVC?.present(popover, animated: true, completion: nil)
    }
}
