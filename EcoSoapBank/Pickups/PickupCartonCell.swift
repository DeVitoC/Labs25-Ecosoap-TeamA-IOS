//
//  PickupCartonCell.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import Combine


class PickupCartonCell: UITableViewCell {
    static var reuseIdentifier: String { String(describing: Self.self) }
    
    private var viewModel: NewCartonViewModel!
    private var cancellables: Set<AnyCancellable> = []

    private lazy var cartonLabel = configure(UILabel()) {
        self.constrainNewSubviewToSafeArea($0, sides: [.top, .bottom], constant: 8)
        NSLayoutConstraint.activate($0.constraints(from: safeAreaLayoutGuide,
                                                   toSides: [.leading, .trailing],
                                                   constant: 20))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        cancellables = []
    }

    func configureCell(for viewModel: NewCartonViewModel) {
        self.viewModel = viewModel

        viewModel.$carton.sink { carton in
            self.cartonLabel.text = "\(carton.product.rawValue.capitalized) — \(carton.percentFull)g"
        }.store(in: &cancellables)
    }
}
