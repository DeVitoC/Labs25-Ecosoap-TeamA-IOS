//
//  PickupController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import Combine


protocol ImpactDataProvider {
    func fetchImpactStats(forPropertyID propertyID: String, _ completion: @escaping ResultHandler<ImpactStats>)
}

class ImpactController {
    
    // MARK: - Public Properties
    
    let user: User
    let dataProvider: ImpactDataProvider
    private(set) var viewModels: [ImpactCellViewModel] = []
    var selectedProperty: Property? {
        UserDefaults.standard.selectedProperty(forUser: user)
    }
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Gets the latest impact stats from the data provider, which in
    /// turn updates the `viewModels` property accordingly.
    /// - Parameter completion: A completion closure that passes back
    /// either an error if something went wrong, or nil if the impact
    /// stats were properly fetched and the view models updated.
    func getImpactStats(_ completion: @escaping (Error?) -> Void) {
        guard let property = selectedProperty else {
            return getImpactStatsForAllProperties(completion)
        }
        dataProvider.fetchImpactStats(forPropertyID: property.id) { [weak self] result in
            switch result {
            case .success(let stats):
                self?.updateViewModels(with: stats)
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func getImpactStatsForAllProperties(_ completion: @escaping (Error?) -> Void) {
        guard let propertyIDs = user.properties?.compactMap({ $0.id }) else {
            return completion(UserError.noProperties)
        }
        var allPropertiesSubscription: AnyCancellable?
        allPropertiesSubscription = propertyIDs
            .map({ [weak self] propertyID in
                Future { promise in
                    self?.dataProvider.fetchImpactStats(forPropertyID: propertyID, promise)
                }
            }).publisher
            .mapError { _ in ESBError.unknown }
            .flatMap { $0 }
            .reduce(ImpactStats(), +)
            .sink(receiveCompletion: { [weak self] fetchResult in
                if case .failure(let error) = fetchResult {
                    completion(error)
                }
                if let sub = allPropertiesSubscription {
                    self?.cancellables.remove(sub)
                }
            }, receiveValue: { [weak self] stats in
                self?.updateViewModels(with: stats)
                completion(nil)
            })
        cancellables.insert(allPropertiesSubscription!)
    }
    
    // MARK: - Init
    
    init(user: User, dataProvider: ImpactDataProvider) {
        self.user = user
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
