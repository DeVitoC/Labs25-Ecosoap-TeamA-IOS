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
    func loadData(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func getToken() throws -> String
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
