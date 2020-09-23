//
//  PaymentHistoryViewController.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/31/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PaymentHistoryViewController: UIViewController {

    // MARK: - Public Properties
    var paymentController: PaymentController?
    
    
    // MARK: - Private Properties
    
    private lazy var paymentCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout())
    private var payments: [Payment] = [] {
        didSet {
            self.paymentCollectionView.reloadData()
        }
    }
    
    private let refreshControl = UIRefreshControl()
    private let cellIdentifier = "PaymentCell"
    private var selectedPropertyObserver: UserDefaultsObservation?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPropertyObserver = UserDefaults.$selectedPropertyIDsByUser.observe { [weak self] _, _ in
            self?.refreshPayments()
        }
        setupCollectionView()
        refreshPayments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.bounds = CGRect(
            x: refreshControl.bounds.origin.x,
            y: -UIRefreshControl.topPadding,
            width: refreshControl.bounds.size.width,
            height: refreshControl.bounds.size.height
        )
    }
    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        view.addSubview(paymentCollectionView)
        paymentCollectionView.dataSource = self
        paymentCollectionView.delegate = self
        paymentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        paymentCollectionView.register(PaymentHistoryCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        paymentCollectionView.backgroundColor = UIColor.tableViewCellBackground
        
        NSLayoutConstraint.activate([
            paymentCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            paymentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paymentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        refreshControl.addTarget(self, action: #selector(refreshControlDidTrigger(_:)), for: .valueChanged)
        paymentCollectionView.refreshControl = refreshControl
    }

    private func compositionalLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [NSCollectionLayoutItem(layoutSize: size)])
        let section = NSCollectionLayoutSection(group: group)
        // Match table view leading padding, add space for refresh control
        section.contentInsets = .init(top: UIRefreshControl.topPadding, leading: 3, bottom: 0, trailing: 0)
       
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func refreshPayments() {
        guard let controller = paymentController else { return }
        refreshControl.beginRefreshing()
        controller.fetchPaymentsForSelectedProperty(completion: { [weak self] result in
            switch result {
            case .success(let payments):
                var sortedPayments: [Payment] = payments
                sortedPayments.sort {
                    guard let date0 = $0.invoicePeriodEndDate, let date1 = $1.invoicePeriodEndDate else { return false }
                    return date0 > date1
                }
                DispatchQueue.main.async {
                    self?.payments = sortedPayments
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presentAlert(for: error)
                }
            }
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        })
    }

    @objc private func refreshControlDidTrigger(_ sender: UIRefreshControl) {
        refreshPayments()
    }
}

extension PaymentHistoryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        defer { paymentCollectionView.performBatchUpdates(nil) }
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if cell?.isSelected ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            return true
        }
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
        cell.payment = payments[indexPath.row]

        return cell
    }
}
