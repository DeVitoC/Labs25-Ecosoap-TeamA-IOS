//
//  ImpactViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


/// Displays the impact a property or all properties is having via Eco-Soap Bank
class ImpactViewController: UIViewController {

    // MARK: - Public Properties
    
    var impactController: ImpactController
    var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Private Properties
    
    private var massUnitObserver: UserDefaultsObservation?
    private var selectedPropertyObserver: UserDefaultsObservation?
    private let refreshControl = UIRefreshControl()

    // MARK: - Init

    /// Initailizes and configures the ImpactViewController
    @available(*, unavailable, message: "Use init(impactController:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(impactController:)`.")
    }
    
    init(impactController: ImpactController) {
        self.impactController = impactController
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.accessibilityLabel = "Impact Statistics"
        view.backgroundColor = .systemGray6
        navigationItem.title = "Impact Summary"

        // Assigns the units of measurement to display based on the user's UserDefaults
        massUnitObserver = UserDefaults.$massUnit.observe { [weak self] _, _ in
            self?.collectionView.reloadData()
        }
        selectedPropertyObserver = UserDefaults.$selectedPropertyIDsByUser.observe { [weak self] _, _ in
            self?.refreshImpactStats()
        }
                
        setUpCollectionView()
        refreshImpactStats()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        refreshControl.bounds = CGRect(
            x: refreshControl.bounds.origin.x,
            y: -UIRefreshControl.topPadding,
            width: refreshControl.bounds.size.width,
            height: refreshControl.bounds.size.height
        )
    }

    // MARK: - Private Methods
    /// Lays out the CollectionView to fill the parent view and configures cell
    private func setUpCollectionView() {
        collectionView.register(
            ImpactCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(ImpactCell.self)
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        view.addSubviewsUsingAutolayout(collectionView)
        
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.addTarget(
            self,
            action: #selector(refreshImpactStats(_:)),
            for: .valueChanged)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    /// Method that fetches the Impact Stats from the server and reloads the collectionview with the new data
    /// - Parameter sender: The sender that called this method. Defaults to **nil** unless called by another UI element
    @objc private func refreshImpactStats(_ sender: Any? = nil) {
        refreshControl.beginRefreshing()

        impactController.getImpactStats { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.presentAlert(for: error)
                    return
                }

                self?.refreshControl.endRefreshing()
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Collection View Data Source

extension ImpactViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        impactController.viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NSStringFromClass(ImpactCell.self),
            for: indexPath) as? ImpactCell else {
                fatalError("Unable to cast cell as \(ImpactCell.self)")
        }
        
        cell.alignment = indexPath.row % 2 == 0 ? .leading : .trailing
        cell.viewModel = impactController.viewModels[indexPath.row]
       
        return cell
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            collectionView.reloadData()
        }
    }
}

// MARK: - Flow Layout Delegate

/// Enum describing several layout sizes
private enum ImpactLayout {
    static let headerHeight: CGFloat = 80
    static let cellAspectRatio: CGFloat = 0.31
    static let sectionInsetTop: CGFloat = 40
    static let sectionInsetBotttom: CGFloat = 40
    static let minimumLineSpacing: CGFloat = 20
}

extension ImpactViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width * ImpactLayout.cellAspectRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Add line spacing if the font scaling is bigger than .large
        if traitCollection.preferredContentSizeCategory > .large {
            return UIFontMetrics.default.scaledValue(for: ImpactLayout.minimumLineSpacing)
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: ImpactLayout.sectionInsetTop,
                     left: 0,
                     bottom: ImpactLayout.sectionInsetBotttom,
                     right: 0)
    }
}
