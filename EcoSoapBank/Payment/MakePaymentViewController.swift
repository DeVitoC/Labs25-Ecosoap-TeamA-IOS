//
//  MakePaymentViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-28.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import Stripe


class MakePaymentViewController: UIViewController {

    private let stripeController: StripeController
    private let paymentContext: STPPaymentContext

    private let currencyFormatter = configure(NumberFormatter()) {
        $0.numberStyle = .currency
    }

    // MARK: - Subviews

    private let priceLabel = configure(UILabel()) {
        //        $0.font = .muli(style: .title1)
        $0.text = ""
    }

    private let paymentOptionsButton = configure(ESBButton()) {
        $0.setTitle("Select Payment Type", for: .normal)
        $0.titleLabel?.font = .preferredMuli(forTextStyle: .title2)
        $0.addTarget(self, action: #selector(choosePayment(_:)), for: .touchUpInside)
    }

    private let paymentIcon = UIImageView()
    private let paymentLabel = configure(UILabel()) {
        $0.font = .preferredMuli(forTextStyle: .title1)
        $0.text = "Paying by: "
    }
    private lazy var paymentStack = configure(UIStackView()) {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = 8
        $0.isHidden = true

        [paymentIcon, paymentLabel].forEach($0.addArrangedSubview(_:))
    }

    private var mainStack = configure(UIStackView()) {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }

    // MARK: - Init / Lifecycle

    init(stripeController: StripeController) {
        self.stripeController = stripeController
        self.paymentContext = stripeController.newPaymentContext()
        super.init(nibName: nil, bundle: nil)

        paymentContext.delegate = self
        paymentContext.hostViewController = self


        priceLabel.text = stringFromContextAmount()
    }

    @available(*, unavailable, message: "Use init(stripeController:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(stripeController:)`.")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.constrainNewSubviewToCenter(mainStack)
        [priceLabel, paymentOptionsButton, paymentLabel]
            .forEach(mainStack.addArrangedSubview(_:))
    }
}

// MARK: - Actions

extension MakePaymentViewController {
    @objc func choosePayment(_ sender: Any?) {
        paymentContext.presentPaymentOptionsViewController()
    }

    func stringFromContextAmount() -> String {
        let decimal = Decimal(paymentContext.paymentAmount) * 0.01
        return currencyFormatter.string(from: decimal as NSDecimalNumber)!
    }
}

// MARK: - Payment Context Delegate

extension MakePaymentViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if paymentContext.loading {
            present(LoadingViewController(), animated: true, completion: nil)
        } else if presentedViewController as? LoadingViewController != nil {
            dismiss(animated: true, completion: nil)
        }

        paymentLabel.text = paymentContext.selectedPaymentOption?.label
        paymentIcon.image = paymentContext.selectedPaymentOption?.image
        paymentStack.isHidden = (paymentContext.selectedPaymentOption != nil)

    }

    func paymentContext(
        _ paymentContext: STPPaymentContext,
        didFailToLoadWithError error: Error
    ) {
        self.presentAlert(for: error)
    }

    func paymentContext(
        _ paymentContext: STPPaymentContext,
        didCreatePaymentResult paymentResult: STPPaymentResult,
        completion: @escaping STPPaymentStatusBlock
    ) {

    }

    func paymentContext(
        _ paymentContext: STPPaymentContext,
        didFinishWith status: STPPaymentStatus,
        error: Error?
    ) {
        switch status {
        case .success:
            ()
        case .error:
            presentAlert(for: error ?? StripeError.unknown)
        case .userCancellation:
            ()
        @unknown default:
            presentAlert(for: StripeError.unknown)
        }
    }
}
