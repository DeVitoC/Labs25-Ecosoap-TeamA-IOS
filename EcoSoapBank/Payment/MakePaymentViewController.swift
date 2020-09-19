//
//  MakePaymentViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-28.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import Stripe


protocol MakePaymentDelegate: AnyObject {
    func cancelPayment()
}


class MakePaymentViewController: UIViewController {

    private let paymentController: PaymentController
    private let payment: NextPaymentDue

    private let stripeController: StripeController?
    private let paymentContext: STPPaymentContext?

    private let currencyFormatter = configure(NumberFormatter()) {
        $0.numberStyle = .currency
    }

    weak var delegate: MakePaymentDelegate?

    // MARK: - Subviews

    private lazy var priceLabel = configure(UILabel()) {
        $0.font = .preferredMuli(forTextStyle: .largeTitle)
        $0.text = stringFromIntegerAmount(payment.amountDue)
    }
    private lazy var dueLabel = configure(UILabel()) {
        $0.font = .preferredMuli(forTextStyle: .headline)
        $0.text = "due"
    }
    private lazy var dueDateLabel = configure(UILabel()) {
        $0.font = .preferredMuli(forTextStyle: .title2)
        guard let dueDate = payment.dueDate else {
            $0.isHidden = true
            return
        }
        $0.text = DateFormatter.default.string(from: dueDate)
    }
    private lazy var dueStack = UIStackView(
        axis: .horizontal,
        alignment: .lastBaseline,
        distribution: .fill,
        spacing: 8,
        arrangedSubviews: [dueLabel, dueDateLabel])

    private lazy var periodLabel = configure(UILabel()) {
        $0.font = .preferredMuli(forTextStyle: .subheadline)
        guard let startDate = payment.invoicePeriodStartDate,
              let endDate = payment.invoicePeriodEndDate
        else {
            $0.isHidden = true
            return
        }

        let startText = DateFormatter.default.string(from: startDate)
        let endText = DateFormatter.default.string(from: endDate)
        $0.text = "for \(startText) — \(endText)"
    }
    private lazy var invoiceButton = configure(UIButton()) {
        guard let invoiceCode = payment.invoiceCode, let url = payment.invoice else {
            $0.isHidden = true
            return
        }
        $0.tintColor = .esbGreen
        $0.setAttributedTitle(
            NSAttributedString(
                string: "Invoice: " + invoiceCode,
                attributes: [
                    .font: UIFont.preferredMuli(forTextStyle: .body, typeface: .semiBold),
                    .foregroundColor: UIColor.esbGreen]),
            for: .normal)
        $0.addTarget(self, action: #selector(openInvoice(_:)), for: .touchUpInside)
    }
    private lazy var makePaymentButton = configure(ESBButton()) {
        $0.setTitle("Make payment", for: .normal)
        $0.addTarget(self, action: #selector(makePayment(_:)), for: .touchUpInside)
    }

    private lazy var mainStack = UIStackView(
        axis: .vertical,
        alignment: .leading,
        distribution: .fill,
        spacing: 8,
        arrangedSubviews: [priceLabel, dueStack, periodLabel, invoiceButton])

    // MARK: - Init / Lifecycle

    init(payment: NextPaymentDue,
         paymentController: PaymentController,
         stripeController: StripeController?
    ) {
        self.payment = payment
        self.paymentController = paymentController
        self.stripeController = stripeController
        self.paymentContext = stripeController?.newPaymentContext()
        super.init(nibName: nil, bundle: nil)

        //paymentContext?.delegate = self
        paymentContext?.hostViewController = self
    }

    /// **Warning**: This initializer is not implemented.
    /// Please use `init(payment:paymentController:stripeController:)`.
    @available(*, unavailable, message: "Use init(payment:paymentController:stripeController:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(payment:paymentController:stripeController:)`.")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground

        navigationItem.title = "Make payment"
        navigationItem.setLeftBarButton(
            UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(cancelTapped(_:))),
            animated: false)

        view.constrainNewSubviewToSafeArea(
            mainStack,
            sides: [.top, .leading, .trailing],
            constant: 12)
        view.constrainNewSubviewToCenter(makePaymentButton, axes: .horizontal)
        NSLayoutConstraint.activate([
            makePaymentButton.topAnchor.constraint(
                equalTo: mainStack.bottomAnchor,
                constant: 20),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(
                greaterThanOrEqualTo: makePaymentButton.bottomAnchor,
                constant: 8)
        ])

    }
}

// MARK: - Actions

extension MakePaymentViewController {
    @objc func makePayment(_ sender: Any?) {
        guard let context = paymentContext else {
            return presentAlert(
                for: ErrorMessage(
                    title: "Coming soon!",
                    message: "In-app payments will be coming in a future release. Thanks for your patience!"))
        }
        context.presentPaymentOptionsViewController()
    }

    @objc func cancelTapped(_ sender: Any?) {
        delegate?.cancelPayment()
    }

    @objc func openInvoice(_ sender: Any? = nil) {
        guard let url = payment.invoice else {
            return presentAlert(
                for: ErrorMessage(
                    title: "No invoice found",
                    message: "We couldn't find the invoice for this payment. Please try again later."))
        }
        UIApplication.shared.open(url)
    }

    func stringFromIntegerAmount(_ amount: Int) -> String {
        let decimal = Decimal(amount) * 0.01
        return currencyFormatter.string(from: decimal as NSDecimalNumber)!
    }
}
