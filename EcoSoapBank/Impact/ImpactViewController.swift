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

    var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    var impactController: ImpactController?
    
    private var massUnitObserver: UserDefaultsObservation?

    /// Initailizes and configures the ImpactViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        navigationItem.title = "Impact Summary"

        // Assigns the units of measurement to display based on the user's UserDefaults
        massUnitObserver = UserDefaults.$massUnit.observe { [weak self] _, _ in
            self?.collectionView.reloadData()
        }
                
        setUpCollectionView()
        refreshImpactStats()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }

    private func setUpCollectionView() {
        collectionView.register(ImpactCell.self, forCellWithReuseIdentifier: ImpactCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        
        view.addSubviewsUsingAutolayout(collectionView)
        collectionView.fillSuperview()
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(
            self,
            action: #selector(refreshImpactStats(_:)),
            for: .valueChanged)
    }

    @objc private func refreshImpactStats(_ sender: Any? = nil) {
        guard let impactController = impactController else { return }
        collectionView.refreshControl?.beginRefreshing()

        impactController.getImpactStats { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.presentAlert(for: error)
                    return
                }

                self?.collectionView.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Collection View Data Source

extension ImpactViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        impactController?.viewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImpactCell.reuseIdentifier, for: indexPath) as? ImpactCell else {
            fatalError("Unable to cast cell as \(ImpactCell.self)")
        }
        
        cell.alignment = indexPath.row % 2 == 0 ? .leading : .trailing
        cell.viewModel = impactController?.viewModels[indexPath.row]
       
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
        if traitCollection.preferredContentSizeCategory > .large {
            return UIFontMetrics.default.scaledValue(for: 20)
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
