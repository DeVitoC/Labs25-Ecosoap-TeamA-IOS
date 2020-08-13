//
//  PickupController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

protocol ImpactDataProvider {
    func fetchImpactStats(_ completion: (Result<ImpactStats, Error>) -> Void)
}

class ImpactController {
    private(set) var viewModels: [ImpactCellViewModel] = []
    
    private var dataProvider: ImpactDataProvider
    
    func getImpactStats(_ completion: (Error?) -> Void) {
        dataProvider.fetchImpactStats { result in
            switch result {
            case .success(let stats):
                updateViewModels(with: stats)
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func updateViewModels(with impactStats: ImpactStats) {
        viewModels = []
        
        if let soapRecycled = impactStats.soapRecycled {
            viewModels.append(
                ImpactCellViewModel(withAmount: soapRecycled,
                                    convertedTo: .pounds,
                                    subtitle: "soap recycled",
                                    image: UIImage(named: "Bottles")!)
            )
        }
        if let bottlesRecycled = impactStats.bottlesRecycled {
            viewModels.append(
                ImpactCellViewModel(withAmount: bottlesRecycled,
                                    convertedTo: .pounds,
                                    subtitle: "bottle amenities\nrecycled",
                                    image: UIImage(named: "Bottles")!)
            )
        }
        if let linensRecycled = impactStats.linensRecycled {
            viewModels.append(
                ImpactCellViewModel(withAmount: linensRecycled,
                                    convertedTo: .pounds,
                                    subtitle: "linens recycled",
                                    image: UIImage(named: "Bottles")!)
            )
        }
        if let paperRecycled = impactStats.paperRecycled {
            viewModels.append(
                ImpactCellViewModel(withAmount: paperRecycled,
                                    convertedTo: .pounds,
                                    subtitle: "paper recycled",
                                    image: UIImage(named: "Bottles")!)
            )
        }
        if let peopleServed = impactStats.peopleServed {
            viewModels.append(
                ImpactCellViewModel(title: String(peopleServed),
                                    subtitle: "people served",
                                    image: UIImage(named: "Bottles")!)
            )
        }
        if let womenEmployed = impactStats.womenEmployed {
            viewModels.append(
                ImpactCellViewModel(title: String(womenEmployed),
                                    subtitle: "women employed",
                                    image: UIImage(named: "Bottles")!)
            )
        }
        
    }

    init(dataProvider: ImpactDataProvider) {
        self.dataProvider = dataProvider
    }
}

// MARK: - Mock Data Provider

/// For placeholder and testing purposes
struct MockImpactDataProvider: ImpactDataProvider {
    enum Error: Swift.Error {
        case shouldFail
    }

    /// Set to `true` for testing networking failures
    var shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    /// Simply returns mock ImpactStats through closure
    /// or `MockImpactStatsProvider.Error.shouldFail` if `shouldFail`
    /// instance property is set to `true`
    func fetchImpactStats(_ completion: (Result<ImpactStats, Swift.Error>) -> Void) {
        guard !shouldFail else {
            completion(.failure(Self.Error.shouldFail))
            return
        }
        
        completion(.success(ImpactStats(soapRecycled: 13090,
                                        bottlesRecycled: 1982,
                                        linensRecycled: 3298,
                                        paperRecycled: 2948,
                                        peopleServed: 323,
                                        womenEmployed: 5)))
    }
}
