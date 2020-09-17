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
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 20
    }

    var payment: Payment? {
        didSet { updateContent() }
    }

    var isExpanded = false {
        didSet { updateLayout() }
    }

    private let dateFormatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
    }

    // MARK: - Subviews

    private lazy var rootStack = UIStackView(
        axis: .horizontal,
        alignment: .firstBaseline,
        distribution: .fill,
        spacing: Padding.tiny,
        arrangedSubviews: [mainStack, disclosureIndicator])
    private lazy var mainStack = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Padding.medium,
        arrangedSubviews: [invoicePeriodLabel, duePaidStack, detailStack, invoiceStack])

    private lazy var duePaidStack = UIStackView(
        axis: .horizontal,
        alignment: .firstBaseline,
        distribution: .fillEqually,
        spacing: Padding.small,
        arrangedSubviews: [
            labeledStack(
                caption: "Amount Due",
                content: iconStack(
                    image: dollarSign(.systemOrange),
                    label: amountDueLabel)),
            labeledStack(
                caption: "Amount Paid",
                content: iconStack(
                    image: dollarSign(.esbGreen),
                    label: amountPaidLabel))])
    private lazy var detailStack = UIStackView(
        axis: .horizontal,
        alignment: .firstBaseline,
        distribution: .fillEqually,
        spacing: Padding.small,
        arrangedSubviews: [
            labeledStack(caption: "Paid", content: paymentDateLabel),
            labeledStack(caption: "Method", content: paymentMethodLabel)])
    private lazy var invoiceStack = UIStackView(
        axis: .horizontal,
        alignment: .lastBaseline,
        distribution: .fillEqually,
        spacing: Padding.small,
        arrangedSubviews: [
            labeledStack(caption: "Invoice", content: invoiceCodeLabel),
            invoiceButton])

    private lazy var invoicePeriodLabel = configure(UILabel()) {
        $0.font = UIFont.preferredMuli(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var amountDueLabel = contentLabel()
    private lazy var amountPaidLabel = contentLabel()
    private lazy var paymentDateLabel = contentLabel()
    private lazy var paymentMethodLabel = contentLabel()
    private lazy var invoiceCodeLabel = contentLabel()
    private lazy var invoiceButton = configure(UIButton()) {
        $0.setAttributedTitle(
            NSAttributedString(string: "Open invoice", attributes: [
                .font: UIFont.preferredMuli(forTextStyle: .body, typeface: .semiBold),
                .foregroundColor: UIColor.esbGreen]),
            for: .normal)
        $0.tintColor = .esbGreen
        $0.setTitleColor(.esbGreen, for: .normal)
        $0.addTarget(self, action: #selector(openInvoice(_:)), for: .touchUpInside)
        $0.titleLabel?.lineBreakMode = .byWordWrapping
        $0.titleLabel?.numberOfLines = 0
        $0.contentHorizontalAlignment = .leading
    }
    private lazy var disclosureIndicator = configure(UIImageView("chevron.down")) {
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

        constrainNewSubviewToSafeArea(rootStack,
                                      sides: [.top, .leading, .trailing],
                                      constant: Padding.medium)
        bottomAnchor.constraint(equalTo: rootStack.bottomAnchor, constant: Padding.large)
            .isActive = true

        // Divider
        configure(UIView()) {
            $0.backgroundColor = .esbSeparator
            constrainNewSubview($0, to: [.bottom, .trailing])
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 0.5),
                $0.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                            constant: Padding.medium)
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

        amountDueLabel.text = dollarString(payment.amountDue as NSNumber)
        amountPaidLabel.text = dollarString(payment.amountPaid as NSNumber)
        invoicePeriodLabel.text = "\(dateFormatter.string(from: invoicePeriodStartDate)) — \(dateFormatter.string(from: invoicePeriodEndDate))"
        paymentDateLabel.text = dateFormatter.string(from: payment.date)
        paymentMethodLabel.text = "\(payment.paymentMethod)"
        invoiceCodeLabel.text = payment.invoiceCode
    }

    private func updateLayout() {
        self.disclosureIndicator.transform = self.isExpanded ?
            CGAffineTransform(rotationAngle: .pi)
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
    private func dollarString(_ amount: NSNumber) -> String {
        String(NumberFormatter.forDollars.string(from: amount)?.dropFirst() ?? "n/a"[...])
    }
    
    private func contentLabel() -> UILabel {
        configure(UILabel()) {
            $0.font = UIFont.preferredMuli(forTextStyle: .callout)
            $0.textColor = UIColor.codGrey.orInverse()
            $0.adjustsFontForContentSizeCategory = true
        }
    }

    private func captionLabel(_ text: String) -> UILabel {
        configure(UILabel()) {
            $0.text = text.uppercased()
            $0.font = .smallCaption
            $0.adjustsFontForContentSizeCategory = true
            $0.textColor = .secondaryLabel
        }
    }

    private func labeledStack(caption: String, content: UIView) -> UIStackView {
        UIStackView(axis: .vertical,
                    alignment: .fill,
                    distribution: .fill,
                    spacing: 0,
                    arrangedSubviews: [captionLabel(caption), content])
    }

    private func iconStack(image: UIImageView, label: UILabel) -> UIStackView {
        UIStackView(axis: .horizontal,
                    alignment: .lastBaseline,
                    distribution: .fill,
                    spacing: 0,
                    arrangedSubviews: [image, label])
    }

    private func dollarSign(_ color: UIColor) -> UIImageView {
        configure(UIImageView("dollarsign.circle.fill",
                              configuration: .init(font: .preferredMuli(forTextStyle: .headline)),
                              tintColor: color)
        ) {
            $0.widthAnchor.constraint(equalTo: $0.heightAnchor).isActive = true
        }
    }
}
