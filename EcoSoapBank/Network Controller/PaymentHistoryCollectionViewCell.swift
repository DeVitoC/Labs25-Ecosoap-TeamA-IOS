//
//  PaymentHistoryCollectionViewCell.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/31/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PaymentHistoryCollectionViewCell: UICollectionViewCell {
    private var payment: Payment? {
        didSet {
            setupUI()
        }
    }
    private lazy var uiInitializers = UIElementInitializers()

    func setupUI() {
        guard let payment = payment,
            let invoicePeriodStartDate = payment.invoicePeriodStartDate,
            let invoicePeriodEndDate = payment.invoicePeriodEndDate,
            let invoiceCode = payment.invoiceCode else {
                return
        }
        let invoiceString = "\(invoicePeriodStartDate) - \(invoicePeriodEndDate)"
        let invoicePeriodLabel = uiInitializers.createLabel(invoiceString, frame: CGRect(origin: .zero, size: .zero), alignment: .left)
        let amountDueLabel = uiInitializers.createLabel("\(payment.amountDue)", frame: .zero, alignment: .left)
        let amountPaidLabel = uiInitializers.createLabel("\(payment.amountPaid)", frame: .zero, alignment: .left)
        let paymentMethodLabel = uiInitializers.createLabel("\(payment.paymentMethod)", frame: .zero, alignment: .left)
        let invoiceNumberLabel = uiInitializers.createLabel("\(invoiceCode)", frame: .zero, alignment: .left)
        let paymentDateLabel = uiInitializers.createLabel("\(payment.date)", frame: .zero, alignment: .left)

        addSubview(invoicePeriodLabel)
        addSubview(amountDueLabel)
        addSubview(amountPaidLabel)
        addSubview(paymentMethodLabel)
        addSubview(invoiceNumberLabel)
        addSubview(paymentDateLabel)

        
    }
}
