//
//  PickupController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine


protocol PickupDataProvider {
    func fetchAllPickups(
        _ completion: @escaping ResultHandler<[Pickup]>)

    func schedulePickup(
        _ pickupInput: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>)
}


enum PickupError: Error {
    case noResult
}


class PickupController: ObservableObject {
    @Published private(set) var pickups: [Pickup] = []
    @Published private(set) var error: Error?

    var user: User

    /// Signals to subscriber (`PickupCoordinator`) that the new pickup view should be shown.
    var presentNewPickup = PassthroughSubject<Void, Never>()

    /// A view model for use with new pickup views.
    ///
    /// The PickupController holds a reference to the view model for later reuse and/or for use with SwiftUI
    /// (where views may inadvertantly reinitialize objects if a reference is not held elsewhere).
    private(set) lazy var schedulePickupViewModel = SchedulePickupViewModel(user: user, delegate: self)

    /// Publishes result of `schedulePickup(_:)` call when data task is completed.
    let pickupScheduleResult = PassthroughSubject<Pickup.ScheduleResult, Error>()

    /// Forwards `newPickupViewModel`'s message to edit the given carton.
    var editCarton = PassthroughSubject<NewCartonViewModel, Never>()

    init(user: User, dataProvider: PickupDataProvider) {
        self.dataProvider = dataProvider
        self.user = user

        fetchAllPickups()
            .handleError { [weak self] error in self?.error = error }
            .sink { [weak self] pickups in
                self?.pickups = pickups.sorted(by: Self.pickupSorter)
        }.store(in: &cancellables)
    }

    func fetchAllPickups() -> AnyPublisher<[Pickup], Error> {
        Future { promise in
            self.dataProvider.fetchAllPickups { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }

    func clearError() {
        error = nil
    }

    // MARK: - Private

    private var dataProvider: PickupDataProvider
    private var schedulePickupCancellables: Set<AnyCancellable> = []
    private var cancellables: Set<AnyCancellable> = []

    private static let pickupSorter = sortDescriptor(keypath: \Pickup.readyDate, by: >)
}

extension PickupController: SchedulePickupViewModelDelegate {
    func schedulePickup(
        for pickupInput: Pickup.ScheduleInput
    ) {
        dataProvider.schedulePickup(pickupInput) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pickupResult):
                guard let pickup = pickupResult.pickup else {
                    return self.pickupScheduleResult.send(completion: .failure(PickupError.noResult))
                }
                self.pickups.append(pickup)
                self.schedulePickupViewModel = SchedulePickupViewModel(user: self.user, delegate: self)
                self.pickupScheduleResult.send(pickupResult)
            case .failure(let error):
                self.error = error
                self.pickupScheduleResult.send(completion: .failure(error))
            }
        }
    }

    func editCarton(for viewModel: NewCartonViewModel) {
        editCarton.send(viewModel)
    }
}
