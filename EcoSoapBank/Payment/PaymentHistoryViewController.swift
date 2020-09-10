//
//  PaymentHistoryViewController.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/31/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PaymentHistoryViewController: UIViewController {

    var paymentController: PaymentController?
    private var paymentCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var payments: [Payment] = [] {
        didSet {
            self.paymentCollectionView.reloadData()
        }
    }


    var cellWidth: CGFloat {
        paymentCollectionView.frame.size.width
    }
    var expandedHeight: CGFloat = 200
    var notExpandedHeight: CGFloat = 80
    var isExpanded = [Bool]()
    let cellIdentifier = "PaymentCell"

    override func loadView() {
        view = BackgroundView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment History"
        setupCollectionView()
        guard let user = paymentController?.user, let properties = user.properties else { return }
        paymentController?.fetchPayments(forPropertyID: properties[0].id, completion: { result in
            switch result {
            case .success(let payments):
                DispatchQueue.main.async {
                    var sortedPayments: [Payment] = payments
                    sortedPayments.sort {
                        guard let date0 = $0.invoicePeriodEndDate, let date1 = $1.invoicePeriodEndDate else { return false }
                        return date0 > date1
                    }
                    self.payments = sortedPayments
                    self.isExpanded = Array(repeating: false, count: payments.count)
                }
            case .failure(let error):
                self.presentAlert(for: error)
            }
        })
    }
    
    func setupCollectionView() {
        view.addSubview(paymentCollectionView)
        paymentCollectionView.dataSource = self
        paymentCollectionView.delegate = self
        paymentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        paymentCollectionView.register(PaymentHistoryCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        paymentCollectionView.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            paymentCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            paymentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paymentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension PaymentHistoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleExpandCell(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        toggleExpandCell(indexPath: indexPath)
    }

    func toggleExpandCell(indexPath: IndexPath) {
        if !isExpanded[indexPath.row] {
            isExpanded = Array(repeating: false, count: payments.count)
        }
        isExpanded[indexPath.row].toggle()
        self.paymentCollectionView.reloadData()
    }
}

extension PaymentHistoryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        payments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath) as? PaymentHistoryCollectionViewCell
            else { return UICollectionViewCell() }
        cell.isExpanded = isExpanded[indexPath.row]
        cell.payment = payments[indexPath.row]

        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
}

extension PaymentHistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        isExpanded[indexPath.row] ? CGSize(width: cellWidth, height: expandedHeight) :
            CGSize(width: cellWidth, height: notExpandedHeight)
    }
}
