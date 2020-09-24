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
    
    // MARK: - IBOutlets
    
    // views
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var headingLabels: [UILabel]!
    @IBOutlet private var notesHeadingLabel: UILabel!
    @IBOutlet private var notesView: UILabel!
    
    // constraints
    @IBOutlet private var tableViewHeight: NSLayoutConstraint!
    @IBOutlet private var collectionViewHeight: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private var cells: [(text: String, detail: String)] {
        [
            ("Confirmation Code", pickup.confirmationCode),
            ("Status", pickup.status.display),
            ("Ready Date", pickup.readyDate.string()),
            ("Pickup Date", pickup.pickupDate?.string() ?? "N/A"),
        ]
    }
    
    // swiftlint:disable force_cast
    private lazy var cartonSizingCell = Bundle.main.loadNibNamed(
        "CartonCollectionViewCell",
        owner: self,
        options: nil
    )?.first as! CartonCollectionViewCell
    // swiftlint:enable force_cast
    
    private lazy var largestCarton: Pickup.Carton? = {
        pickup.cartons.sorted { carton1, carton2 -> Bool in
            guard let contents1 = carton1.contents,
                let contents2 = carton2.contents else { return true }
            
            return contents1.product.rawValue.count > contents2.product.rawValue.count
        }.first
    }()
    
    private let verticalCartonCellPadding: CGFloat = 10

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
        setUpCartonCollectionView()
        
        setUpViews()
        updateViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeight.constant = tableView.contentSize.height
        
        let cellHeight = cartonSizingCell
                            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                            .height
        collectionViewHeight.constant = cellHeight + verticalCartonCellPadding
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.flashScrollIndicators()
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
    
    private func setUpCartonCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            UINib(nibName: "CartonCollectionViewCell", bundle: .main),
            forCellWithReuseIdentifier: NSStringFromClass(CartonCollectionViewCell.self)
        )
        collectionView.accessibilityLabel = "Cartons in pickup"
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
            withReuseIdentifier: NSStringFromClass(CartonCollectionViewCell.self),
            for: indexPath) as? CartonCollectionViewCell else {
                fatalError("Could not cast cell as \(CartonCollectionViewCell.self)")
        }
        cell.carton = pickup.cartons[indexPath.item]

        return cell
    }
}

// MARK: - Carton Collection View Flow Layout Delegate

extension PickupDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        cartonSizingCell.carton = largestCarton
        cartonSizingCell.setNeedsLayout()
        cartonSizingCell.layoutIfNeeded()
        return cartonSizingCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
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
