//
//  GraphQLController.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
}

/// Class containing methods for communicating with GraphQL backend
class GraphQLController {

    // MARK: - Properties
    private let session: DataLoader
    private let url = URL(string: "http://35.208.9.187:9094/ios-api-1/")!

    // Setting up the url request
    private lazy var request: URLRequest = {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }()

    // MARK: - INIT
    init(session: DataLoader = URLSession.shared) {
        self.session = session
    }

    // MARK: - Request methods

    /// Method for GraphQL query requests
    /// - Parameters:
    ///   - query: The intended query in string format
    ///   - completion: Completion handler that passes back a Result of type Profile or Error
    ///   - type: The Model Type for the JSON Decoder to decode
    func queryRequest<T: Decodable>(_ type: T.Type,
                                  query: String,
                                  completion: @escaping (Result<T, Error>) -> Void) {
        // Add body to query request
        let body: [String: String] = ["query": query]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        session.loadData(with: request) { data, _, error in
            if let error = error {
                NSLog("\(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                NSLog("Data is nil")
                return
            }

            completion(self.decodeJSON(type, data: data))
        }
    }

    /// Method for GraphQL mutation requests
    /// - Parameters:
    ///   - mutationQuery: The intended mutation query in string format
    ///   - variables: The variables to be passed in the request
    ///   - completion: Completion handler that passes back a Result of type Profile or Error
    ///   - type: The Model Type for the JSON Decoder to decode
    func mutationRequest<T: Decodable>(_ type: T.Type,
                         mutationQuery: String,
                         variables: [Any] = [],
                         completion: @escaping (Result<T, Error>) -> Void) {
        // Add body to mutate request
        let body: [String: Any] = ["mutation": mutationQuery, "variables": variables]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        session.loadData(with: request) { data, _, error in
            if let error = error {
                NSLog("\(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                NSLog("Data is nil")
                return
            }

            completion(self.decodeJSON(type, data: data))
        }
    }

    // MARK: - Helper Methods

    /// Method to decode JSON Data to usable Type
    /// - Parameter data: The JSON Data returned from the request
    /// - Parameter type: The Model Type for the JSON Decoder to decode
    /// - Returns: Either an Error or the Decoded object
    private func decodeJSON<T: Decodable>(_ type: T.Type, data: Data) -> Result<T, Error> {
        do {
            // Decode data as ProfileQuery and pass the stored object of type Profile through completion
            let dict = try JSONDecoder().decode([String: T].self, from: data)
            guard let result = dict["data"] else {
                throw GraphQLError.noData
            }
            return .success(result)
        } catch {
            NSLog("\(error)")
            return .failure(error)
        }
    }
}

enum GraphQLError: Error {
    case noData
}
