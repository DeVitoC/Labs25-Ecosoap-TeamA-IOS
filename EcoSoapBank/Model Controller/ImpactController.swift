//
//  PickupController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

protocol ImpactProvider {
    func fetchImpactStats(_ completion: @escaping (Result<ImpactStats, Error>) -> Void)
}

class ImpactController {
    private(set) var viewModels: [ImpactCellViewModel] = []
    
    private let dataProvider: ImpactProvider
    
    /// Gets the latest impact stats from the data provider, which in
    /// turn updates the `viewModels` property accordingly.
    /// - Parameter completion: A completion closure that passes back
    /// either an error if something went wrong, or nil if the impact
    /// stats were properly fetched and the view models updated.
    func getImpactStats(_ completion: @escaping (Error?) -> Void) {
        dataProvider.fetchImpactStats { [weak self] result in
            switch result {
            case .success(let stats):
                self?.updateViewModels(with: stats)
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    // MARK: - Init
    
    init(dataProvider: ImpactProvider) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - Private Methods
    
    /// This function updates the array of view models for the Impact Cells
    /// using the `ImpactStats` passed in, as well as the unit preference of
    /// the user. It creates each view model with an appropriate subtitle and
    /// image that corresponds with the statistic.
    private func updateViewModels(with impactStats: ImpactStats) {
        viewModels = []
        
        if let soapRecycled = impactStats.soapRecycled {
            viewModels.append(
                ImpactCellViewModel(amount: soapRecycled,
                                    unit: .grams,
                                    subtitle: "soap recycled",
                                    image: .soap)
            )
        }
        if let bottlesRecycled = impactStats.bottlesRecycled {
            viewModels.append(
                ImpactCellViewModel(amount: bottlesRecycled,
                                    unit: .grams,
                                    subtitle: "bottle amenities\nrecycled",
                                    image: .bottles)
            )
        }
        if let linensRecycled = impactStats.linensRecycled {
            viewModels.append(
                ImpactCellViewModel(amount: linensRecycled,
                                    unit: .grams,
                                    subtitle: "linens recycled",
                                    image: .linens)
            )
        }
        if let paperRecycled = impactStats.paperRecycled {
            viewModels.append(
                ImpactCellViewModel(amount: paperRecycled,
                                    unit: .grams,
                                    subtitle: "paper recycled",
                                    image: .paper)
            )
        }
        if let peopleServed = impactStats.peopleServed {
            viewModels.append(
                ImpactCellViewModel(amount: peopleServed,
                                    unit: .people,
                                    subtitle: "people served",
                                    image: .people)
            )
        }
        if let womenEmployed = impactStats.womenEmployed {
            viewModels.append(
                ImpactCellViewModel(amount: womenEmployed,
                                    unit: .people,
                                    subtitle: "women employed",
                                    image: .women)
            )
        }
    }
}

