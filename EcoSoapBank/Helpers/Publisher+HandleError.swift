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
    func handleError(_ handle: @escaping (Error) -> Void) -> AnyPublisher<Output, Never> {
        self.handleEvents(
            receiveSubscription: nil,
            receiveOutput: nil,
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    handle(error)
                }
            },
            receiveCancel: nil,
            receiveRequest: nil)
            .map { output -> Output? in output }
            .replaceError(with: nil)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
