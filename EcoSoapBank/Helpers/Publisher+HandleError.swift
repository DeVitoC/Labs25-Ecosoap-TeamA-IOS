//
//  Publisher+HandleError.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-18.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Combine


extension Publisher {
    /// Handles the error case of a publisher and passes on a type-erased Publisher that never fails.
    func handleError(_ handle: @escaping (Failure) -> Void) -> AnyPublisher<Output, Never> {
        self.map { out -> Output? in out }
            .catch { error -> Just<Output?> in
                handle(error)
                return Just(nil)
            }.compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
