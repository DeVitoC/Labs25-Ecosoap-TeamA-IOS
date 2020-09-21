//
//  DataLoader.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import KeychainAccess


protocol DataLoader {
    /// Fetch the data using the provided request and return it asynchronously using the provided closure.
    func loadData(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    /// Fetch the token from cached memory if present and not expired.
    ///
    /// Throws an error if token is not present or if it has expired.
    func getToken() throws -> String
    /// Remove the token from cached memory if present.
    func removeToken()
}

extension URLSession: DataLoader {
    func loadData(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.dataTask(with: request, completionHandler: completion).resume()
    }

    func getToken() throws -> String {
        try Keychain.Okta.getToken()
    }

    func removeToken() {
        Keychain.Okta.removeToken()
    }
}
