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
    private var paymentCollectionView: UICollectionView?
    private var payments: [Payment] = []

    override func loadView() {
        view = BackgroundView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = paymentController?.user, let properties = user.properties else { return }
        paymentCollectionView?.register(PaymentHistoryCollectionViewCell.self, forCellWithReuseIdentifier: "PaymentCell")
        paymentCollectionView?.backgroundColor = .clear
        self.payments = paymentController?.fetchPayments(forPropertyID: properties[0].id) ?? []
        print(self.payments)
    }
}

extension PaymentHistoryViewController: UICollectionViewDelegate { }

extension PaymentHistoryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        paymentController?.payments.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PaymentCell",
            for: indexPath) as? PaymentHistoryCollectionViewCell
            else { return UICollectionViewCell() }

        return cell
    }

}
