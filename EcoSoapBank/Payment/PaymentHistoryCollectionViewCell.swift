//
//  PaymentHistoryCollectionViewCell.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/31/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class PaymentHistoryCollectionViewCell: UICollectionViewCell {
    private enum Padding {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 20
    }

    var payment: Payment? {
        didSet {
            updateContent()
        }
    }

    var isExpanded = false {
        didSet {
            updateLayout()
        }
    }

    private let dateFormatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
    }

    // MARK: - Subviews

    private lazy var rootStack = UIStackView(axis: .horizontal, alignment: .firstBaseline, distribution: .fill, spacing: Padding.small)
    private lazy var mainStack = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: Padding.small)
    private lazy var duePaidStack = UIStackView(axis: .horizontal, alignment: .firstBaseline, distribution: .fillEqually, spacing: Padding.small)
    private lazy var detailStack = UIStackView(axis: .horizontal, alignment: .firstBaseline, distribution: .fillEqually, spacing: Padding.small)
    private lazy var invoiceStack = UIStackView(axis: .horizontal, alignment: .lastBaseline, distribution: .fillEqually, spacing: Padding.small)
    private lazy var invoicePeriod = contentLabel()
    private lazy var amountDue = contentLabel()
    private lazy var amountPaid = contentLabel()
    private lazy var paymentDate = contentLabel()
    private lazy var paymentMethod = contentLabel()
    private lazy var invoiceCode = contentLabel()
    private lazy var invoiceButton = configure(UIButton()) {
        $0.setTitle("Open invoice", for: .normal)
        $0.tintColor = .esbGreen
        $0.setTitleColor(.esbGreen, for: .normal)
        $0.addTarget(self, action: #selector(openInvoice(_:)), for: .touchUpInside)
        $0.titleLabel?.lineBreakMode = .byWordWrapping
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.textAlignment = .left
        $0.contentHorizontalAlignment = .leading
    }
    private lazy var disclosureIndicator = configure(UIImageView(systemName: "chevron.right")) {
        $0.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .secondarySystemBackground

        constrainNewSubviewToSafeArea(rootStack, constant: 12)
        [mainStack, disclosureIndicator]
            .forEach(rootStack.addArrangedSubview(_:))

        mainStack.addArrangedSubview(invoicePeriod)

        [labeledStack([captionLabel("Amount Due"), amountDue]), labeledStack([captionLabel("Amount Paid"), amountPaid])]
            .forEach(duePaidStack.addArrangedSubview(_:))
        mainStack.addArrangedSubview(duePaidStack)

        [labeledStack([captionLabel("Paid"), paymentDate]), labeledStack([captionLabel("Method"), paymentMethod])]
            .forEach(detailStack.addArrangedSubview(_:))
        [labeledStack([captionLabel("Invoice"), invoiceCode]), invoiceButton]
            .forEach(invoiceStack.addArrangedSubview(_:))
        mainStack.addArrangedSubview(detailStack)
        mainStack.addArrangedSubview(invoiceStack)
        configure(UIView()) {
            $0.backgroundColor = .tertiaryLabel
            constrainNewSubview($0, to: [.bottom, .trailing])
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 0.5),
                $0.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12)
            ])
        }

        updateLayout()
    }

    // MARK: - Update

    private func updateContent() {
        guard let payment = payment,
            let invoicePeriodStartDate = payment.invoicePeriodStartDate,
            let invoicePeriodEndDate = payment.invoicePeriodEndDate
            else { return }

        amountDue.text = NumberFormatter.forDollars.string(from: payment.amountDue as NSNumber)
        amountPaid.text = NumberFormatter.forDollars.string(from: payment.amountPaid as NSNumber)
        invoicePeriod.text = "\(dateFormatter.string(from: invoicePeriodStartDate)) — \(dateFormatter.string(from: invoicePeriodEndDate))"
        paymentDate.text = dateFormatter.string(from: payment.date)
        paymentMethod.text = "\(payment.paymentMethod)"
        invoiceCode.text = payment.invoiceCode
    }

    private func updateLayout() {
        self.disclosureIndicator.transform = self.isExpanded ?
            CGAffineTransform(rotationAngle: .pi / 2)
            : .identity
        self.detailStack.isHidden = !self.isExpanded
        self.invoiceStack.isHidden = !self.isExpanded
    }

    @objc private func openInvoice(_ sender: Any?) {
        if let urlString = payment?.invoice, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Subview factory

extension PaymentHistoryCollectionViewCell {
    private func contentLabel() -> UILabel {
        configure(UILabel()) {
            $0.font = .muli(typeface: .semiBold)
        }
    }

    private func captionLabel(_ text: String) -> UILabel {
        configure(UILabel()) {
            $0.text = text.uppercased()
            $0.font = .muli(style: .caption1)
            $0.textColor = .secondaryLabel
        }
    }

    private func labeledStack(_ newSubViews: [UIView]) -> UIStackView {
        let stack = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 4)
        newSubViews.forEach { stack.addArrangedSubview($0) }
        return stack
    }
}
