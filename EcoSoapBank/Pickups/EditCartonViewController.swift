//
//  EditCartonViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-21.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class EditCartonViewController: UIViewController {
    let label = configure(UILabel()) {
        $0.text = "Hello, world!"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.constrainNewSubviewToSides(label)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 300),
            view.heightAnchor.constraint(equalToConstant: 300)
        ])
        preferredContentSize =
            view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
