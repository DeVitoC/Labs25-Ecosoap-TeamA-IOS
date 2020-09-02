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
    var user: User?

    override func loadView() {
        view = BackgroundView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user, let properties = user.properties else { return }
        paymentCollectionView?.register(PaymentHistoryCollectionViewCell.self, forCellWithReuseIdentifier: "PaymentCell")
        paymentCollectionView?.backgroundColor = .clear
        if let paymentFuture = paymentController?.fetchPayments(forPropertyId: properties[0].id) as? [Payment] {
            payments = paymentFuture
        } else {
            NSLog("Did not get Payment array from fetchPayments")
        }


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentCell", for: indexPath) as? PaymentHistoryCollectionViewCell else { return UICollectionViewCell() }

        return cell
    }


}
