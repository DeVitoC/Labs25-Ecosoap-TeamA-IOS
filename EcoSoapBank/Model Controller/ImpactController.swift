//
//  PickupController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

protocol ImpactDataProvider {
    func fetchImpactStats(_ completion: (Result<ImpactStats, Error>) -> Void)
}

class ImpactController {
    private(set) var impactStats: ImpactStats?
    
    private var dataProvider: ImpactDataProvider
    
    func getImpactStats(_ completion: (Error?) -> Void) {
        dataProvider.fetchImpactStats { result in
            switch result {
            case .success(let stats):
                self.impactStats = stats
                completion(nil)
            case .failure(let error):
                completion(error)
            }
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
        completion(.success(ImpactStats(
            stats: [
                .soapRecycled: 1000
            ]
        )))
    }
}
