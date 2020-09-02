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
    func fetchPayments(forPropertyId propertyId: String,
                       _ completion: @escaping ResultHandler<[Payment]>)
    func makePayment(_ paymentInput: Payment,
                     completion: @escaping ResultHandler<Payment>)
}

class PaymentController {
    private(set) var payments: [Payment] = []
    private let dataProvider: PaymentDataProvider
    private(set) var user: User
    private var properties: [Property]? {
        user.properties
    }

    init(user: User, dataProvider: PaymentDataProvider) {
        self.user = user
        self.dataProvider = dataProvider
    }

    func fetchPayments(forPropertyId propertyId: String) -> Future<[Payment], Error> {

        Future { promise in
            self.dataProvider.fetchPayments(forPropertyId: propertyId) { [weak self] result in
                if case .success(let payments) = result {
                    DispatchQueue.main.async {
                        self?.payments = payments
                    }
                    promise(result)
                }
            }
        }
    }

    func fetchPaymentsForAllProperties() -> AnyPublisher<[Payment], Error> {
        guard let properties = properties, !properties.isEmpty else {
            return Future {
                $0(.failure(UserError.noProperties))
            }
            .eraseToAnyPublisher()
        }
        var futures = properties.map { fetchPayments(forPropertyId: $0.id)
        }
        var combined = futures.popLast()!.eraseToAnyPublisher()
        while let future = futures.popLast() {
            combined = combined.append(future).eraseToAnyPublisher()
        }

        return combined
    }
    
}
