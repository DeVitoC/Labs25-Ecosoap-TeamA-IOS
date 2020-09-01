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

    override func loadView() {
        view = BackgroundView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentCollectionView?.register(PaymentHistoryCollectionViewCell.self, forCellWithReuseIdentifier: "PaymentCell")
        paymentCollectionView?.backgroundColor = .clear

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
