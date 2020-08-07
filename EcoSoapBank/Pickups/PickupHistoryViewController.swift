//
//  PickupHistoryViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class PickupHistoryViewController: UIViewController {
    lazy var label = configure(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Hello world"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

