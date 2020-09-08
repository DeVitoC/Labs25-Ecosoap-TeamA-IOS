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

    init(user: User, dataProvider: PaymentDataProvider) {
        self.user = user
        self.dataProvider = dataProvider
    }

    func fetchPayments(forPropertyID propertyID: String, completion: @escaping (Result<[Payment], Error>) -> Void) {
        dataProvider.fetchPayments(forPropertyID: propertyID, completion)
    }
    
}
