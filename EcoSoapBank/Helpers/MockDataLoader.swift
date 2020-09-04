//
//  MockDataLoader.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class MockDataLoader: DataLoader {
    var data: Data?
    var error: Error?

    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }

    func loadData(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion(data, nil, error)
    }

    func getToken() throws -> String {
        if let error = error {
            throw error
        } else {
            return "fake token"
        }
    }

    func removeToken() {
        NSLog("(fake) token \"removed\" (ie no-op)")
    }
}
