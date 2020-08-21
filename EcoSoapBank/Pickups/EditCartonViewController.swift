//
//  EditCartonViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-21.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


protocol EditCartonViewDelegate: AnyObject {
    func editCartonViewControllerDidDisappear(_ editCartonVC: EditCartonViewController)
}


class EditCartonViewController: UIViewController {
    let label = configure(UILabel()) {
        $0.text = "Hello, world!"
    }

    weak var delegate: EditCartonViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.constrainNewSubviewToSides(label)

        preferredContentSize = CGSize(width: 300, height: 200)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: preferredContentSize.width),
            view.heightAnchor.constraint(equalToConstant: preferredContentSize.height)
        ])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.editCartonViewControllerDidDisappear(self)
    }
}


extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}
