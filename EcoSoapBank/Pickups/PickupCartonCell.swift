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
        self.constrainNewSubview($0, with: [
            $0.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        cancellables = []
    }

    func configureCell(for viewModel: NewCartonViewModel) {
        self.viewModel = viewModel

        viewModel.$carton.sink { carton in
            self.cartonLabel.text = "\(carton.product) — \(carton.weight)g"
        }.store(in: &cancellables)
    }
}
