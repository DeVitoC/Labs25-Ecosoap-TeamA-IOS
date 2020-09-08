//
//  PaymentHistoryCollectionViewCell.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/31/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PaymentHistoryCollectionViewCell: UICollectionViewCell {
    var payment: Payment? {
        didSet {
            setupUI()
        }
    }
    private lazy var uiInitializers = UIElementInitializers()
    var isExpanded = false
    var labelHeight = 25

    func setupUI() {
        guard let payment = payment,
            let invoicePeriodStartDate = payment.invoicePeriodStartDate,
            let invoicePeriodEndDate = payment.invoicePeriodEndDate,
            let invoiceCode = payment.invoiceCode else {
                return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let invoiceString = "Period: \(dateFormatter.string(from: invoicePeriodStartDate)) - \(dateFormatter.string(from: invoicePeriodEndDate))"
        let invoicePeriodLabel = uiInitializers.createLabel(invoiceString, frame: .zero, alignment: .left)
        let amountDueLabel = uiInitializers.createLabel("Amt Due:  \(payment.amountDue)", frame: .zero, alignment: .left)
        let amountPaidLabel = uiInitializers.createLabel("Amt Paid: \(payment.amountPaid)", frame: .zero, alignment: .left)

        addSubview(invoicePeriodLabel)
        addSubview(amountDueLabel)
        addSubview(amountPaidLabel)


        NSLayoutConstraint.activate([
            invoicePeriodLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            invoicePeriodLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            amountDueLabel.topAnchor.constraint(equalTo: invoicePeriodLabel.bottomAnchor, constant: 10),
            amountDueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            amountPaidLabel.topAnchor.constraint(equalTo: amountDueLabel.topAnchor),
            amountPaidLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (frame.width / 2))
        ])

        if isExpanded {
            let paymentDateLabel = uiInitializers.createLabel("Payment Date: \(dateFormatter.string(from: payment.date))", frame: .zero, alignment: .left)
            let paymentMethodLabel = uiInitializers.createLabel("Method: \(payment.paymentMethod)", frame: .zero, alignment: .left)
            let invoiceNumberLabel = uiInitializers.createLabel("Invoice Code: \(invoiceCode)", frame: .zero, alignment: .left)
            let invoiceLabel = uiInitializers.createLabel("Invoice: pdf", frame: .zero, alignment: .left)

            addSubview(paymentDateLabel)
            addSubview(paymentMethodLabel)
            addSubview(invoiceNumberLabel)
            addSubview(invoiceLabel)
        }
    }
}
