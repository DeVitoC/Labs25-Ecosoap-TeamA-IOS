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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = BackgroundView()
        view.addSubviewsUsingAutolayout(background)
        background.fillSuperview()
                
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - Collection View Data Source

extension ImpactViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        impactController.viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImpactCell.reuseIdentifier, for: indexPath) as? ImpactCell else {
            fatalError("Could not cast cell as \(ImpactCell.self)")
        }
        
        cell.alignment = indexPath.row % 2 == 0 ? .leading : .trailing
        cell.viewModel = impactController.viewModels[indexPath.row]
       
        return cell
    }
}

// MARK: - Collection View Delegate

extension ImpactViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width * 0.31)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
    }
}
