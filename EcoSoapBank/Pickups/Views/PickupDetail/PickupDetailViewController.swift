//
//  PickupDetailViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-19.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI


class PickupDetailViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var pickup: Pickup { didSet { updateViews() } }
    
    // MARK: - Private Properties
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var headingLabels: [UILabel]!
    @IBOutlet private var notesHeadingLabel: UILabel!
    @IBOutlet private var notesView: UILabel!
    
    private var cells: [(text: String, detail: String)] {
        [
            ("Confirmation Code", pickup.confirmationCode),
            ("Status", pickup.status.display),
            ("Ready Date", pickup.readyDate.string()),
            ("Pickup Date", pickup.pickupDate?.string() ?? "N/A"),
        ]
    }

    // MARK: - Init / Lifecycle
    
    init?(coder: NSCoder, pickup: Pickup) {
        self.pickup = pickup
        super.init(coder: coder)
    }
    
    @available(*, unavailable, message: "Use init(coder:pickup:)")
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:pickup:)`")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pickup Details"
        
        tableView.dataSource = self
        collectionView.dataSource = self
        
        setUpViews()
        updateViews()
    }
    
    // MARK: - Private Functions
    
    private func setUpViews() {
        headingLabels.forEach { $0.font = .preferredMuli(forTextStyle: .headline) }
        notesView.font = .preferredMuli(forTextStyle: .subheadline)
        notesView.textColor = UIColor.codGrey.orInverse()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        notesView.text = pickup.notes
        notesHeadingLabel.isHidden = pickup.notes.isEmpty
    }
}

// MARK: - Table View Data Source

extension PickupDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickupDetailCell", for: indexPath)
        
        cell.textLabel?.text = cells[indexPath.row].text
        cell.textLabel?.font = .preferredMuli(forTextStyle: .headline)
        cell.detailTextLabel?.text = cells[indexPath.row].detail
        cell.detailTextLabel?.font = .preferredMuli(forTextStyle: .callout)
        cell.detailTextLabel?.textColor = UIColor.codGrey.orInverse()
        return cell
    }
}

// MARK: - Carton Collection View Data Source

extension PickupDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pickup.cartons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NSStringFromClass(PickupDetailCartonCell.self),
            for: indexPath) as? PickupDetailCartonCell else {
                fatalError("Could not cast cell as \(PickupDetailCartonCell.self)")
        }
        cell.carton = pickup.cartons[indexPath.item]
        return cell
    }
}

// MARK: - SwiftUI Wrapper

extension PickupDetailViewController {
    private struct _Representable: UIViewControllerRepresentable {
        let pickup: Pickup

        func makeUIViewController(context: Context) -> PickupDetailViewController {
            PickupDetailViewController.fromStoryboard { coder in
                PickupDetailViewController(coder: coder, pickup: self.pickup)
            }!
        }

        func updateUIViewController(
            _ uiViewController: PickupDetailViewController,
            context: Context
        ) {
            uiViewController.pickup = pickup
        }
    }

    struct Representable: View {
        let pickup: Pickup

        var body: some View {
            _Representable(pickup: pickup)
                .navigationBarTitle("Pickup Details")
        }
    }
}
