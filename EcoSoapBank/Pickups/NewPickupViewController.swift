//
//  NewPickupViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class NewPickupViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, Pickup.CartonContents>

    var viewModel: NewPickupViewModel

    // MARK: - Views

    private lazy var cartonsLabel = configureSectionLabel(titled: "Cartons")
    private lazy var dateLabel = configureSectionLabel(titled: "Pickup Date")
    private lazy var notesLabel = configureSectionLabel(titled: "Notes")

    private lazy var tableView = UITableView()
    private lazy var dataSource = DataSource(
        tableView: tableView,
        cellProvider: cell(for:at:with:))
    private lazy var addCartonButton = configure(UIButton()) {
        $0.setImage(.add, for: .normal)
        $0.addTarget(self, action: #selector(addCarton), for: .touchUpInside)
    }

    private lazy var datePicker = configure(UIDatePicker()) {
        $0.datePickerMode = .date
    }
    private lazy var notesView = configure(UITextView()) {
        $0.delegate = self
    }

    // MARK: - Init / Lifecycle

    @available(*, unavailable, message: "Use init(viewModel:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(viewModel:)`.")
    }

    init(viewModel: NewPickupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
}

// MARK: - View Setup / Update

extension NewPickupViewController {
    private func setUpViews() {
        view.addSubviews(
            usingAutolayout: true,
            cartonsLabel,
            dateLabel,
            notesLabel
        )

        tableView.dataSource = dataSource
    }

    private func configureSectionLabel(titled title: String) -> UILabel {
        let label = UILabel()
        label.text = title.uppercased()
        label.font = .muli(style: .caption1)
        return label
    }

    private func cell(
        for tableView: UITableView,
        at indexPath: IndexPath,
        with carton: Pickup.CartonContents
    ) -> UITableViewCell? {
        return nil
    }
}

// MARK: - Actions

extension NewPickupViewController {
    @objc private func addCarton() {
        viewModel.addCarton()
    }
}

// MARK: - Text Delegates

extension NewPickupViewController: UITextViewDelegate {}
