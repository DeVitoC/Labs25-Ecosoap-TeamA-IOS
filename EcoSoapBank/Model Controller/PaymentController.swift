//
//  PaymentController.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/27/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

protocol PaymentDataProvider {
    func fetchPaymentsByPropertyId(_ completion: @escaping ResultHandler<[Payment]>)
    func makePayment(_ completion: @escaping ResultHandler<Payment>)
}

class PaymentController {
    private(set) var payments: [Payment] = []
    private let graphQLController = GraphQLController()
    var user: User

    init(user: User) {
        self.user = user
    }

    func fetchAllPayments() {

        
    }

    func makePayment() {


    }
    
}
