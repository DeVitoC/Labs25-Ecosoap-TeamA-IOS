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

/// Coordinator that initializes and starts the ImpactViewController
class PickupCoordinator: FlowCoordinator {

    // MARK: - Properties
    private let pickupController: PickupController
    private(set) var user: User

    // rootVC is the base controller that will be opened.
    // In this case, the UIHostingController that will allow SwiftUI views to be displayed on the ViewController
    private(set) lazy var rootVC: UIViewController = UIHostingController(
        // Initializes view with PickupHistoryView with the passed in pickupController
        rootView: PickupHistoryView(
            pickupController: pickupController,
            schedulePickup: { [weak self] in self?.scheduleNewPickup() }))

    private var cancellables = Set<AnyCancellable>()
    private var scheduleVC: SchedulePickupViewController?
    var scheduleVM: SchedulePickupViewModel?

    /// Initializer that takes in a **User** and **PickupDataProvider** and initializes the **PickupCoordinator**
    /// - Parameters:
    ///   - user: A **User** object that will provide the information for the **PickupViewController**
    ///   - dataProvider: Takes an object that conforms to the protocol **PickupDataProvider**. Allows for either live or mock data.
    init(user: User, dataProvider: PickupDataProvider) {
        self.user = user
        self.pickupController = PickupController(
            user: user,
            dataProvider: dataProvider)

        // subscribe to and respond to model controller messages
        pickupController.fetchPickupsForSelectedProperty()
            .receive(on: DispatchQueue.main)
            .handleError { [weak rootVC] error in rootVC?.presentAlert(for: error) }
            .sink { _ in }
            .store(in: &cancellables)
    }

    /// Starts the rootVC as the current VC. Initialized with a "cube.box" image for the tab
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
    func scheduleNewPickup() {
        guard user.properties?.first != nil else {
            return rootVC.presentAlert(for: UserError.noProperties)
        }
        // see `UtilityFunctions.swift` `Optional` extension and infix operator
        let viewController = scheduleVC ??= newScheduleVC()
        let nav = configure(UINavigationController(rootViewController: viewController)) {
            $0.modalPresentationStyle = .fullScreen
        }
        rootVC.present(nav, animated: true, completion: nil)
    }

    private func handlePickupScheduleResult(_ pickupResult: Pickup.ScheduleResult) {
        let alert = successAlert(for: pickupResult)
        rootVC.dismiss(animated: true) { [unowned rootVC] in
            rootVC.present(alert, animated: true)
            self.scheduleVC = nil
            self.scheduleVM = nil
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
        return SchedulePickupViewController(viewModel: viewModel)
    }
}

// MARK: - Delegate conformance

extension PickupCoordinator: SchedulePickupViewModelDelegate {
    func editCarton(for cartonVM: NewCartonViewModel) {
        guard scheduleVC?.isViewLoaded == true else { return }

        let popover = editCartonVC(for: cartonVM)
        popover.popoverPresentationController?.sourceView =
            scheduleVC?.sourceViewForCartonEditingPopover()

        scheduleVC?.present(popover, animated: true, completion: nil)
    }

    func cancelPickup() {
        guard let nav = rootVC.presentedViewController as? UINavigationController,
            nav.viewControllers.first as? SchedulePickupViewController != nil
            else { return }
        rootVC.dismiss(animated: true, completion: nil)
    }

    func schedulePickup(
        for input: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>
    ) {
        (rootVC.presentedViewController ?? rootVC).present(
            LoadingViewController(loadingText: "Scheduling pickup..."),
            animated: true)

        self.pickupController.schedulePickup(for: input)
            .receive(on: DispatchQueue.main)
            .handleError({ [weak self] error in
                self?.rootVC.presentAlert(for: error)
                completion(.failure(error))
            }).sink(receiveValue: { [weak self] result in
                self?.handlePickupScheduleResult(result)
                completion(.success(result))
            }).store(in: &self.cancellables)
    }
}
