//
//  StripeController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-28.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Stripe


enum StripeError: Error {
    case invalidURL
    case unknown
}


class StripeController: NSObject {
    var backendURL: URL

    private(set) var customerContext: STPCustomerContext!

    private let user: User

    init(user: User, backendURL: URL) {
        self.user = user
        self.backendURL = backendURL

        super.init()

        self.customerContext = STPCustomerContext(keyProvider: self)
    }

    func newPaymentContext() -> STPPaymentContext {
        configure(STPPaymentContext(customerContext: customerContext)) {
            $0.paymentAmount = 500 // TODO: replace with actual price
        }
    }
}

// MARK: - Customer Key Provider

extension StripeController: STPCustomerEphemeralKeyProvider {
    func createCustomerKey(
        withAPIVersion apiVersion: String,
        completion: @escaping STPJSONResponseCompletionBlock
    ) {
        let urlComponents = configure(URLComponents(
            url: backendURL.appendingPathComponent("ephemeral_keys"),
            resolvingAgainstBaseURL: false)
        ) {
            $0?.queryItems = [URLQueryItem(name: "api_version",
                                           value: apiVersion)]
        }
        guard let url = urlComponents?.url else {
            return completion(nil, StripeError.invalidURL)
        }
        let request = configure(URLRequest(url: url)) {
            $0.httpMethod = "POST"
        }

        URLSession.shared.dataTask(with: request
        ) { data, response, error in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = (try? JSONSerialization
                    .jsonObject(with: data, options: []) as? [String: Any])
                    as [String: Any]??
                else {
                    return completion(nil, error ?? StripeError.unknown)
            }
            completion(json, nil)
        }.resume()
    }
}
