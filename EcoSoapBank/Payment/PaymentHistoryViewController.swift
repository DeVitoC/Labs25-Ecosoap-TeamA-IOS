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
    private lazy var paymentCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout())
    private var payments: [Payment] = [] {
        didSet {
            self.paymentCollectionView.reloadData()
        }
    }

    var cellWidth: CGFloat {
        paymentCollectionView.frame.size.width
    }

    var isExpanded = [Bool]()
    let cellIdentifier = "PaymentCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Payment History"
        setupCollectionView()
        guard let user = paymentController?.user, let properties = user.properties else { return }
        paymentController?.fetchPayments(forPropertyID: properties[0].id, completion: { result in
            switch result {
            case .success(let payments):
                DispatchQueue.main.async {
                    self.payments = payments
                    self.isExpanded = Array(repeating: false, count: payments.count)
                }
            case .failure(let error):
                print(error.localizedDescription)
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

    private func compositionalLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100))
        return UICollectionViewCompositionalLayout(
            section: NSCollectionLayoutSection(
                group: .vertical(
                    layoutSize: size,
                    subitems: [NSCollectionLayoutItem(layoutSize: size)])))
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

        return cell
    }
}
