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

    private lazy var dueLabel = configure(UILabel()) {
        $0.font = .preferredMuli(forTextStyle: .headline)
        $0.text = "Amount due:"
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    private lazy var amountLabel = configure(UILabel()) {
        $0.font = .preferredMuli(forTextStyle: .largeTitle, typeface: .bold)
        $0.text = stringFromIntegerAmount(payment.amountDue)
    }
    private lazy var amountDueStack = UIStackView(
        axis: .horizontal,
        alignment: .lastBaseline,
        distribution: .fill,
        spacing: 12,
        arrangedSubviews: [dueLabel, amountLabel])

    private lazy var dueDateStack: UIStackView = keyValueView(
        caption: "Due on:",
        content: textForDate(payment.dueDate))

    private lazy var periodStack: UIStackView = keyValueView(
        caption: "For period:",
        content: "\(textForDate(payment.invoicePeriodStartDate)) — \(textForDate(payment.invoicePeriodEndDate))")

    private lazy var invoiceButton = configure(LabelHuggingButton()) {
        guard let invoiceCode = payment.invoiceCode, let url = payment.invoice else {
            $0.isHidden = true
            return
        }
        $0.tintColor = .esbGreen
        $0.setAttributedTitle(
            NSAttributedString(
                string: invoiceCode,
                attributes: [
                    .font: UIFont.preferredMuli(forTextStyle: .body, typeface: .semiBold),
                    .foregroundColor: UIColor.esbGreen
                ]),
            for: .normal)
        $0.contentHorizontalAlignment = .right
//        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        $0.titleEdgeInsets = .zero
//        $0.contentEdgeInsets = .zero
        $0.addTarget(self, action: #selector(openInvoice(_:)), for: .touchUpInside)
    }
    private lazy var invoiceStack = keyValueView(
        caption: "Invoice (open in browser):",
        content: invoiceButton)

    private lazy var makePaymentButton = configure(ESBButton()) {
        $0.setTitle("Make payment", for: .normal)
        $0.addTarget(self, action: #selector(makePayment(_:)), for: .touchUpInside)
    }

    private lazy var mainStack = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 8,
        arrangedSubviews: [
            amountDueStack,
            horizontalDivider(),
            dueDateStack,
            horizontalDivider(),
            periodStack,
            horizontalDivider(),
            invoiceStack,
            horizontalDivider(),
        ])

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
        view.backgroundColor = .systemGray6

        navigationItem.title = "Next Payment"
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

    // MARK: - Subview Factory

    private func keyValueView(caption: String, content: String) -> UIStackView {
        let contentView = configure(UILabel()) {
            $0.text = content
            $0.font = .preferredMuli(forTextStyle: .callout)
            $0.textColor = UIColor.codGrey.orInverse()
            $0.textAlignment = .right
        }
        return keyValueView(caption: caption, content: contentView)
    }

    private func keyValueView(caption: String, content: UIView) -> UIStackView {
        let captionLabel = configure(UILabel()) {
            $0.text = caption
            $0.font = .preferredMuli(forTextStyle: .headline)
        }
        captionLabel.setContentHuggingPriority(.defaultHigh + 2, for: .horizontal)
        return UIStackView(
            axis: .horizontal,
            alignment: .lastBaseline,
            distribution: .fill,
            spacing: 4,
            arrangedSubviews: [captionLabel, content])
    }

    private func textForDate(_ date: Date?) -> String {
        if let actualDate = date {
            return DateFormatter.default.string(from: actualDate)
        } else {
            return "???"
        }
    }

    private func horizontalDivider() -> UIView {
        configure(UIView()) {
            $0.backgroundColor = .systemGray4
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
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
