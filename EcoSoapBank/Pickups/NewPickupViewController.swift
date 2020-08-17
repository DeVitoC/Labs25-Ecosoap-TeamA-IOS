//
//  NewPickupViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI


class NewPickupViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, NewCartonViewModel>

    var viewModel: NewPickupViewModel

    // MARK: - Views

    private lazy var cartonsLabel = configureSectionLabel(titled: "Cartons")
    private lazy var dateLabel = configureSectionLabel(titled: "Pickup Date")
    private lazy var notesLabel = configureSectionLabel(titled: "Notes")

    private lazy var tableView = configure(UITableView()) {
        $0.register(PickupCartonCell.self,
                    forCellReuseIdentifier: PickupCartonCell.reuseIdentifier)
    }
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
    private lazy var scheduleButton = configure(UIButton()) {
        $0.setTitle("Schedule Pickup", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .link
        $0.layer.cornerRadius = 10
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
        // add subviews, basic constraints, `tamic`
        view.constrainNewSubviewToSafeArea(cartonsLabel, sides: [.top, .leading])
        view.constrainNewSubviewToSafeArea(addCartonButton, sides: [.top, .trailing])
        view.constrainNewSubview(tableView, to: [.leading, .trailing])
        view.constrainNewSubviewToSafeArea(dateLabel, sides: [.leading, .trailing])
        view.constrainNewSubview(datePicker, to: [.leading, .trailing])
        view.constrainNewSubviewToSafeArea(notesLabel, sides: [.leading, .trailing])
        view.constrainNewSubviewToSafeArea(notesView, sides: [.leading, .trailing])
        view.constrainNewSubviewToSafeArea(scheduleButton, sides: [.bottom])

        // remaining constraints
        NSLayoutConstraint.activate([
            addCartonButton.leadingAnchor.constraint(
                greaterThanOrEqualTo: cartonsLabel.trailingAnchor,
                constant: 8),
            tableView.topAnchor.constraint(equalTo: cartonsLabel.bottomAnchor, constant: 8),
            dateLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            notesLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            notesView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8),
            notesView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),
            scheduleButton.topAnchor.constraint(equalTo: notesView.bottomAnchor, constant: 20),
            scheduleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

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
        with carton: NewCartonViewModel
    ) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PickupCartonCell.reuseIdentifier,
            for: indexPath)
            as? PickupCartonCell
            else {
                preconditionFailure("NewPickupViewController.tableView failed to dequeue NewPickupCartonCell.")
        }
        cell.configureCell(for: viewModel.cartons[indexPath.row])
        return cell
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

// MARK: - ViewControllerRepresentable

struct NewPickupView: UIViewControllerRepresentable {
    typealias UIViewControllerType = NewPickupViewController

    private var viewModel: NewPickupViewModel

    init(viewModel: NewPickupViewModel) {
        self.viewModel = viewModel
    }

    func makeUIViewController(context: Context) -> NewPickupViewController {
        NewPickupViewController(viewModel: viewModel)
    }

    func updateUIViewController(
        _ uiViewController: NewPickupViewController,
        context: Context
    ) { }
}
