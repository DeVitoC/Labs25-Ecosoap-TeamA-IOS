//
//  NewPickupViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI
import Combine


class NewPickupViewController: UIViewController {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, NewCartonViewModel>

    private var viewModel: NewPickupViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var tableViewHeight: NSLayoutConstraint =
        tableView.heightAnchor.constraint(equalToConstant: 0)

    // MARK: - Views

    private lazy var cartonsLabel = configureSectionLabel(titled: "Cartons")
    private lazy var dateLabel = configureSectionLabel(titled: "Pickup Date")
    private lazy var notesLabel = configureSectionLabel(titled: "Notes")

    private lazy var tableView = configure(UITableView()) {
        $0.register(PickupCartonCell.self,
                    forCellReuseIdentifier: PickupCartonCell.reuseIdentifier)
        $0.delegate = self
    }
    private lazy var dataSource = DataSource(
        tableView: tableView,
        cellProvider: cell(for:at:with:))
    private lazy var addCartonButton = configure(UIButton()) {
        $0.setImage(.add, for: .normal)
        $0.addTarget(self, action: #selector(addCarton), for: .touchUpInside)
        $0.contentEdgeInsets = configure(UIEdgeInsets(), with: { ei in
            ei.top = 4
            ei.left = 4
            ei.right = 4
            ei.bottom = 4
        })
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
        $0.contentEdgeInsets = configure(UIEdgeInsets(), with: { ei in
            ei.top = 8
            ei.left = 8
            ei.right = 8
            ei.bottom = 8
        })
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

        // subscribe to view model cartons, update data source on change
        viewModel.$cartons
            .sink(receiveValue: updateDataSource(with:))
            .store(in: &cancellables)
        updateDataSource(with: viewModel.cartons)
    }
}

// MARK: - View Setup / Update

extension NewPickupViewController {
    private func setUpViews() {
        view.backgroundColor = .secondarySystemBackground

        // add subviews, basic constraints, `tamic`
        view.constrainNewSubviewToSafeArea(cartonsLabel, sides: [.top, .leading], constant: 20)
        view.constrainNewSubviewToSafeArea(addCartonButton, sides: [.top], constant: 20)
        view.constrainNewSubview(tableView, to: [.leading, .trailing])
        view.constrainNewSubviewToSafeArea(dateLabel, sides: [.leading, .trailing], constant: 20)
        view.constrainNewSubview(datePicker, to: [.leading, .trailing])
        view.constrainNewSubviewToSafeArea(notesLabel, sides: [.leading, .trailing], constant: 20)
        view.constrainNewSubviewToSafeArea(notesView, sides: [.leading, .trailing], constant: 20)
        view.constrainNewSubviewToSafeArea(scheduleButton, sides: [.bottom], constant: 20)

        // remaining constraints
        NSLayoutConstraint.activate([
            addCartonButton.leadingAnchor.constraint(greaterThanOrEqualTo: cartonsLabel.trailingAnchor, constant: 8),
            addCartonButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: cartonsLabel.bottomAnchor, constant: 8),
            tableViewHeight,
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
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PickupCartonCell.reuseIdentifier,
                for: indexPath)
                as? PickupCartonCell
            else {
                preconditionFailure("NewPickupViewController.tableView failed to dequeue NewPickupCartonCell.")
        }
        cell.configureCell(for: carton)
        return cell
    }

    private func updateDataSource(with cartons: [NewCartonViewModel]) {
        let snapshot = configure(Snapshot()) {
            $0.appendSections([0])
            $0.appendItems(cartons, toSection: 0)
        }
        dataSource.apply(snapshot)
        UIView.animate(withDuration: 0.2) { [unowned tableViewHeight, unowned tableView] in
            guard !cartons.isEmpty else {
                tableViewHeight.constant = 0
                return
            }
            tableViewHeight.constant = tableView.contentSize.height - CGFloat(cartons.count * 6)
        }
    }
}

// MARK: - Actions

extension NewPickupViewController {
    @objc private func addCarton() {
        viewModel.addCarton()
    }

    @objc private func schedulePickup() {
        viewModel.schedulePickup()
    }
}

// MARK: - Delegates

extension NewPickupViewController: UITextViewDelegate {}

extension NewPickupViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        // set up swipe to delete

        let delete = UIContextualAction(
            style: .destructive,
            title: "Remove",
            handler: { [unowned viewModel] _, _, completion in
                viewModel.removeCarton(at: indexPath.row)
                completion(true)
        })
        delete.backgroundColor = .systemRed

        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = true

        return config
    }
}

// MARK: - ViewControllerRepresentable

extension NewPickupViewController {
    struct Representable: UIViewControllerRepresentable {
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
}

// MARK: - Data Source

extension NewPickupViewController {
    class DataSource: UITableViewDiffableDataSource<Int, NewCartonViewModel> {
        override func tableView(
            _ tableView: UITableView,
            canEditRowAt indexPath: IndexPath
        ) -> Bool {
            true
        }
    }
}
