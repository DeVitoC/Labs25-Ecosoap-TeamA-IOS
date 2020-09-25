//
//  MockImpactProvider.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/21/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

private var statsByPropertyID: [String: ImpactStats] = [:]

/// For placeholder and testing purposes
struct MockImpactProvider: ImpactDataProvider {
    /// Set to `true` for testing networking failures
    var shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    /// Simply returns mock ImpactStats through closure
    /// or `MockError.shouldFail` if `shouldFail`
    /// instance property is set to `true`
    func fetchImpactStats(forPropertyID propertyID: String,
                          _ completion: (Result<ImpactStats, Swift.Error>) -> Void) {
        guard !shouldFail else {
            completion(.mockFailure())
            return
        }
        
        if let stats = statsByPropertyID[propertyID] {
            completion(.success(stats))
            return
        }
        
        let stats = ImpactStats(soapRecycled: Int.random(in: 50_000...200_000),
                                bottlesRecycled: Int.random(in: 20_000...100_000),
                                linensRecycled: Int.random(in: 20_000...100_000),
                                paperRecycled: Int.random(in: 20_000...100_000),
                                peopleServed: Int.random(in: 1000...10_000),
                                womenEmployed: Int.random(in: 5...10))
        
        statsByPropertyID[propertyID] = stats
        completion(.success(stats))
    }
}
