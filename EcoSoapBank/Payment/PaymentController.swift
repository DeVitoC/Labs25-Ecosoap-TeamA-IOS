//
//  PaymentController.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/27/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine


protocol PaymentDataProvider {
    func fetchPayments(forPropertyID propertyID: String,
                       _ completion: @escaping (Result<[Payment], Error>) -> Void)
    func makePayment(_ paymentInput: Payment,
                     completion: @escaping (Result<Payment, Error>) -> Void)
}

class PaymentController {
    private let dataProvider: PaymentDataProvider
    private(set) var user: User
    private var properties: [Property]? {
        user.properties
    }
    private var selectedProperty: Property? {
        UserDefaults.standard.selectedProperty(forUser: user)
    }

    var cancellables = Set<AnyCancellable>()

    init(user: User, dataProvider: PaymentDataProvider) {
        self.user = user
        self.dataProvider = dataProvider
    }

    func fetchPayments(forPropertyID propertyID: String, completion: @escaping (Result<[Payment], Error>) -> Void) {
        dataProvider.fetchPayments(forPropertyID: propertyID, completion)
    }

    func fetchPaymentsForAllProperties(completion: @escaping ResultHandler<[Payment]>) {
        guard let propertyIDs = properties?.compactMap({ $0.id }) else {
            return completion(.failure(UserError.noProperties))
        }
        var allPropertiesSubscription: AnyCancellable?
        allPropertiesSubscription = propertyIDs
            .map({ [weak self] propertyID in
                Future { promise in
                    self?.fetchPayments(forPropertyID: propertyID, completion: promise)
                }
            }).publisher
            .mapError { _ in PickupError.unknown }
            .flatMap { $0 }
            .collect()
            .map { arrays in arrays.flatMap { $0 } }
            .sink(receiveCompletion: { [weak self] fetchResult in
                if case .failure(let error) = fetchResult {
                    completion(.failure(error))
                }
                if let sub = allPropertiesSubscription {
                    self?.cancellables.remove(sub)
                }
            }, receiveValue: { payments in
                completion(.success(payments))
            })
        cancellables.insert(allPropertiesSubscription!)
    }

    func fetchPaymentsForSelectedProperty(completion: @escaping ResultHandler<[Payment]>) {
        if let property = selectedProperty {
            fetchPayments(forPropertyID: property.id, completion: completion)
        } else {
            fetchPaymentsForAllProperties(completion: completion)
        }
    }
}
