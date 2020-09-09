//
//  MockImpactProvider.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/21/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

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
        
        completion(.success(ImpactStats(soapRecycled: 13090,
                                        bottlesRecycled: 1982,
                                        linensRecycled: 3298,
                                        paperRecycled: 2948,
                                        peopleServed: 323,
                                        womenEmployed: 5)))
    }
}
