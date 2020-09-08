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
    

    func setupUI() {
        guard let payment = payment,
            let invoicePeriodStartDate = payment.invoicePeriodStartDate,
            let invoicePeriodEndDate = payment.invoicePeriodEndDate,
            let invoiceCode = payment.invoiceCode else {
                return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let mainStackView = uiInitializers.createElementStackView(axis: .vertical, alignment: .fill, distribution: .equalSpacing)
        let bottomStackView = uiInitializers.createElementStackView(alignment: .fill)
        let amountStackView = uiInitializers.createElementStackView(axis: .vertical, alignment: .leading)
        let paymentStackView = uiInitializers.createElementStackView(axis: .vertical, alignment: .leading)
        let invoiceStackView = uiInitializers.createElementStackView(axis: .vertical, alignment: .trailing)
        let invoiceString = "Period: \(dateFormatter.string(from: invoicePeriodStartDate)) - \(dateFormatter.string(from: invoicePeriodEndDate))"
        let invoicePeriodLabel = uiInitializers.createLabel(invoiceString, frame: CGRect(origin: .zero, size: .zero), alignment: .left)
        let amountDueLabel = uiInitializers.createLabel("Amt Due: \(payment.amountDue)", frame: .zero, alignment: .left)
        let amountPaidLabel = uiInitializers.createLabel("Amt Paid: \(payment.amountPaid)", frame: .zero, alignment: .left)
        let paymentMethodLabel = uiInitializers.createLabel("Method: \(payment.paymentMethod)", frame: .zero, alignment: .left)
        let paymentDateLabel = uiInitializers.createLabel("Payment Date: \(dateFormatter.string(from: payment.date))", frame: .zero, alignment: .left)
        let invoiceNumberLabel = uiInitializers.createLabel("Invoice Code: \(invoiceCode)", frame: .zero, alignment: .left)
        let invoiceLabel = uiInitializers.createLabel("Invoice: pdf", frame: .zero, alignment: .left)

        addSubview(mainStackView)
        mainStackView.addArrangedSubview(invoicePeriodLabel)
        mainStackView.addArrangedSubview(bottomStackView)
        bottomStackView.addArrangedSubview(amountStackView)
        bottomStackView.addArrangedSubview(paymentStackView)
        bottomStackView.addArrangedSubview(invoiceStackView)
        amountStackView.addArrangedSubview(amountDueLabel)
        amountStackView.addArrangedSubview(amountPaidLabel)
        paymentStackView.addArrangedSubview(paymentDateLabel)
        paymentStackView.addArrangedSubview(paymentMethodLabel)
        invoiceStackView.addArrangedSubview(invoiceNumberLabel)
        invoiceStackView.addArrangedSubview(invoiceLabel)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
