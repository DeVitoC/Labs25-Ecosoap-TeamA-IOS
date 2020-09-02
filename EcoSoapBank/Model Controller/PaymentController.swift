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
                       _ completion: @escaping (Result<[Payment], Error>) -> Void)
    func makePayment(_ paymentInput: Payment,
                     completion: @escaping (Result<Payment, Error>) -> Void)
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

    func fetchPayments(forPropertyId propertyId: String) -> [Payment]? {
        var payments: [Payment]?

        dataProvider.fetchPayments(forPropertyId: propertyId) { result in
            switch result {
            case .success(let payments):
                self.payments = payments
            case .failure(let error):
                print(error.localizedDescription)
                payments = nil
            }
        }
        return payments
    }
    
}
