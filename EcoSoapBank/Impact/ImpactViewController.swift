//
//  ImpactViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class ImpactViewController: UIViewController {
    
    private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var impactController = ImpactController(dataProvider: MockImpactDataProvider())
    
    var massUnitObserver: UserDefaultsObservation?
    
    
    override func loadView() {
        view = BackgroundView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        massUnitObserver = UserDefaults.$massUnit.observe { [weak self] _, _ in
            self?.collectionView.reloadData()
        }
                
        setUpCollectionView()

        impactController.getImpactStats { error in
            if let error = error {
                print(error)
                return
            }
            
            collectionView.reloadData()
        }
    }
    
    private func setUpCollectionView() {
        collectionView.register(ImpactCell.self, forCellWithReuseIdentifier: ImpactCell.reuseIdentifier)
        collectionView.register(ImpactHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ImpactHeaderView.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        
        view.addSubviewsUsingAutolayout(collectionView)
        collectionView.fillSuperview()
    }
}

// MARK: - Collection View Data Source

extension ImpactViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind,
                                              withReuseIdentifier: ImpactHeaderView.reuseIdentifier,
                                              for: indexPath) as? ImpactHeaderView else {
            fatalError("Unable to cast view as \(ImpactHeaderView.self)")
        }
        header.title = "Impact Summary"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        impactController.viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImpactCell.reuseIdentifier, for: indexPath) as? ImpactCell else {
            fatalError("Unable to cast cell as \(ImpactCell.self)")
        }
        
        cell.alignment = indexPath.row % 2 == 0 ? .leading : .trailing
        cell.viewModel = impactController.viewModels[indexPath.row]
       
        return cell
    }
}

// MARK: - Flow Layout Delegate

private enum ImpactLayout {
    static let headerHeight: CGFloat = 80
    static let cellAspectRatio: CGFloat = 0.31
    static let sectionInsetTop: CGFloat = 40
    static let sectionInsetBotttom: CGFloat = 40
}

extension ImpactViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: ImpactLayout.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width * ImpactLayout.cellAspectRatio)
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
