//
//  SchedulePickupViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI
import Combine


class SchedulePickupViewController: KeyboardHandlingViewController {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, NewCartonViewModel>

    private var viewModel: SchedulePickupViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var tableViewHeight: NSLayoutConstraint =
        tableView.heightAnchor.constraint(equalToConstant: 0)

    // MARK: - Views

    private lazy var cartonsLabel = configureSectionLabel(titled: "Cartons")
    private lazy var propertyLabel = configureSectionLabel(titled: "Property")
    private lazy var readyDateLabel = configureSectionLabel(titled: "Ready Date")
    private lazy var notesLabel = configureSectionLabel(titled: "Notes")

    private lazy var tableView = configure(UITableView()) {
        $0.register(NewCartonCell.self,
                    forCellReuseIdentifier: NewCartonCell.reuseIdentifier)
        $0.delegate = self
    }
    private lazy var dataSource = DataSource(
        tableView: tableView,
        cellProvider: cell(for:at:with:))
    private lazy var addCartonButton = configure(UIButton(type: .system)) {
        $0.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 30),
            forImageIn: .normal)

        $0.setImage(UIImage.plusSquareFill.withTintColor(.white), for: .normal)
        let title = NSAttributedString(
            string: "Add Carton",
            attributes: [
                NSAttributedString.Key.font: UIFont.muli(),
        ])
        $0.setAttributedTitle(title, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 6)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = .zero
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(addCarton), for: .touchUpInside)
    }
    private lazy var propertyField = configure(CursorlessTextField()) {
        $0.inputView = propertyPicker
        $0.borderStyle = .roundedRect
        $0.text = viewModel.selectedProperty.name
    }
    private lazy var propertyPicker = InputPickerView(
        data: viewModel.properties,
        rowLabel: \.name,
        onSelect: { [weak self] in self?.setProperty($0) }
    )
    private lazy var readyDateField = configure(CursorlessTextField()) {
        $0.inputView = datePicker
        $0.borderStyle = .roundedRect
        $0.text = viewModel.readyDate.string()
    }
    private lazy var datePicker = configure(UIDatePicker()) {
        $0.datePickerMode = .date
        $0.minimumDate = Date()
    }
    private lazy var notesView = configure(ESBTextView()) {
        $0.delegate = self
        $0.font = .muli(style: .body)
    }
    private lazy var scheduleButton = configure(ESBButton()) {
        $0.setTitle("Schedule Pickup", for: .normal)
        $0.addTarget(self,
                     action: #selector(schedulePickup),
                     for: .touchUpInside)
        $0.colorScheme = .whiteOnGreen
    }
    private lazy var cancelButton = UIBarButtonItem(
        barButtonSystemItem: .cancel,
        target: self,
        action: #selector(cancelPickup(_:))
    )

    // MARK: - Init / Lifecycle

    @available(*, unavailable, message: "Use init(viewModel:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(viewModel:)`.")
    }

    init(viewModel: SchedulePickupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        bindToViewModel()
    }
}

// MARK: - Setup / Update

extension SchedulePickupViewController {
    private func setUpViews() {
        view.backgroundColor = .secondarySystemBackground
        title = "New Pickup"

        navigationItem.setLeftBarButton(cancelButton, animated: false)

        // add subviews, basic constraints, `tamic`
        contentView.constrainNewSubviewToSafeArea(cartonsLabel, sides: [.top, .leading], constant: 20)
        contentView.constrainNewSubview(tableView, to: [.leading, .trailing])
        contentView.constrainNewSubview(addCartonButton, to: [.leading], constant: -14)
        contentView.constrainNewSubviewToSafeArea(readyDateLabel, sides: [.leading, .trailing], constant: 20)
        contentView.constrainNewSubviewToSafeArea(readyDateField, sides: [.leading, .trailing], constant: 20)
        contentView.constrainNewSubviewToSafeArea(notesLabel, sides: [.leading, .trailing], constant: 20)
        contentView.constrainNewSubviewToSafeArea(notesView, sides: [.leading, .trailing], constant: 20)
        contentView.constrainNewSubview(scheduleButton, to: [.leading, .trailing], constant: -20)

        var remainingConstraints = [
            addCartonButton.heightAnchor.constraint(equalToConstant: 30),
            tableView.topAnchor.constraint(equalTo: cartonsLabel.bottomAnchor, constant: 8),
            tableView.topAnchor.constraint(equalTo: addCartonButton.bottomAnchor, constant: 8),
            tableViewHeight,
            addCartonButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 2),

            readyDateField.topAnchor.constraint(equalTo: readyDateLabel.bottomAnchor, constant: 8),
            notesLabel.topAnchor.constraint(equalTo: readyDateField.bottomAnchor, constant: 20),
            notesView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8),
            notesView.heightAnchor.constraint(equalToConstant: 150),
            scheduleButton.topAnchor.constraint(equalTo: notesView.bottomAnchor, constant: 20),
            scheduleButton.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: 20)
        ]

        if viewModel.properties.count > 1 {
            contentView.constrainNewSubviewToSafeArea(propertyLabel, sides: [.leading, .trailing], constant: 20)
            contentView.constrainNewSubviewToSafeArea(propertyField, sides: [.leading, .trailing], constant: 20)
            remainingConstraints += [
                propertyLabel.topAnchor.constraint(equalTo: addCartonButton.bottomAnchor, constant: 20),
                propertyField.topAnchor.constraint(equalTo: propertyLabel.bottomAnchor, constant: 8),
                readyDateLabel.topAnchor.constraint(equalTo: propertyField.bottomAnchor, constant: 20)

            ]
        } else {
            remainingConstraints.append(
                readyDateLabel.topAnchor.constraint(equalTo: addCartonButton.bottomAnchor, constant: 20)
            )
        }

        // remaining constraints
        NSLayoutConstraint.activate(remainingConstraints)

        tableView.dataSource = dataSource
    }

    private func bindToViewModel() {
        notesView.text = viewModel.notes
        datePicker.date = viewModel.readyDate
        datePicker.addTarget(self,
                             action: #selector(setReadyDate(_:)),
                             for: .valueChanged)

        // subscribe to view model cartons, update data source on change
        viewModel.$cartons
            .sink(receiveValue: update(fromCartons:))
            .store(in: &cancellables)
        update(fromCartons: viewModel.cartons)
    }

    private func configureSectionLabel(titled title: String) -> UILabel {
        let label = UILabel()
        label.text = title.uppercased()
        label.font = .muli(style: .caption1)
        label.textColor = .secondaryLabel
        return label
    }

    private func cell(
        for tableView: UITableView,
        at indexPath: IndexPath,
        with carton: NewCartonViewModel
    ) -> UITableViewCell? {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NewCartonCell.reuseIdentifier,
                for: indexPath)
                as? NewCartonCell
            else {
                preconditionFailure("NewPickupViewController.tableView failed to dequeue NewPickupCartonCell.")
        }
        cell.configureCell(for: carton)
        return cell
    }

    private func update(fromCartons cartons: [NewCartonViewModel]) {
        // update table view data source
        let snapshot = configure(Snapshot()) {
            $0.appendSections([0])
            $0.appendItems(cartons, toSection: 0)
        }
        dataSource.apply(snapshot)
        UIView.animate(withDuration: 0.3) { [unowned self] in
            defer { self.view.layoutIfNeeded() }
            guard !cartons.isEmpty else {
                self.tableViewHeight.constant = 0
                return
            }
            self.tableViewHeight.constant =
                self.tableView.contentSize.height
                - (CGFloat(cartons.count) * 7.5)
        }
    }
}

// MARK: - Actions

extension SchedulePickupViewController {
    @objc private func addCarton(_ sender: Any) {
        viewModel.addCarton()
    }

    @objc private func cancelPickup(_ sender: Any) {
        viewModel.cancelPickup()
    }

    @objc private func schedulePickup(_ sender: Any) {
        viewModel.schedulePickup()
    }

    @objc private func setReadyDate(_ sender: UIDatePicker) {
        viewModel.readyDate = sender.date
        readyDateField.text = sender.date.string()
    }

    private func setProperty(_ selectedProperty: Property) {
        viewModel.selectedProperty = selectedProperty
        propertyField.text = selectedProperty.name
    }
}

// MARK: - Delegates

// TextViewDelegate (superclass already conforms)
extension SchedulePickupViewController {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.notes = textView.text
    }
}

extension SchedulePickupViewController: UITableViewDelegate {
    // set up swipe to delete
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        .remove { [unowned viewModel] _, _, completion in
            viewModel.removeCarton(atIndex: indexPath.row)
            completion(true)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.editCarton(atIndex: indexPath.row)
    }
}

extension SchedulePickupViewController: UIPopoverPresentationControllerDelegate {
    func sourceViewForCartonEditingPopover() -> UIView {
        guard
            let idx = tableView.indexPathForSelectedRow,
            let selectedCell = tableView.cellForRow(at: idx)
            else { return tableView }
        return selectedCell
    }

    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) {
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }

    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        .none
    }
}

// MARK: - ViewControllerRepresentable

extension SchedulePickupViewController {
    // Enables use with SwiftUI
    struct Representable: UIViewControllerRepresentable {
        private var viewModel: SchedulePickupViewModel

        init(viewModel: SchedulePickupViewModel) {
            self.viewModel = viewModel
        }

        func makeUIViewController(context: Context) -> SchedulePickupViewController {
            SchedulePickupViewController(viewModel: viewModel)
        }

        func updateUIViewController(
            _ uiViewController: SchedulePickupViewController,
            context: Context
        ) { }
    }
}

// MARK: - Data Source

extension SchedulePickupViewController {
    class DataSource: UITableViewDiffableDataSource<Int, NewCartonViewModel> {
        // allows user deletion of cells
        override func tableView(
            _ tableView: UITableView,
            canEditRowAt indexPath: IndexPath
        ) -> Bool {
            true
        }
    }
}


// MARK: - Preview


struct NewPickupViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SchedulePickupViewController.Representable(
                viewModel: SchedulePickupViewModel(user: .placeholder(),
                                                   delegate: nil))

            SchedulePickupViewController.Representable(
                viewModel: SchedulePickupViewModel(user: .placeholder(),
                                                   delegate: nil))
                .environment(\.colorScheme, .dark)
        }

    }
}
