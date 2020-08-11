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

    private let url = URL(string: "http://35.208.9.187:9094/ios-api-1/")!
    // Setting up the url request
    private lazy var request: URLRequest = {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }()

    // MARK: - Request methods

    /// Method for GraphQL query requests
    /// - Parameters:
    ///   - query: The intended query in string format
    ///   - session: The URLSession used for the request. By default this is URLSession.shared
    ///   - completion: Completion handler that passes back a Result of type Profile or Error
    func queryRequest(query: String,
                      session: URLSession = URLSession.shared,
                      completion: @escaping (Result<Profile, Error>) -> Void) {
        // Add body to query request
        let body: [String: String] = ["query": query]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        session.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("\(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                NSLog("Data is nil")
                return
            }

            completion(self.decodeJSON(data: data))
        }.resume()
    }

    /// Method for GraphQL mutation requests
    /// - Parameters:
    ///   - mutationQuery: The intended mutation query in string format
    ///   - variables: The variables to be passed in the request
    ///   - session: The URLSession used for the request. By default this is URLSession.shared
    ///   - completion: Completion handler that passes back a Result of type Profile or Error
    func mutationRequest(mutationQuery: String,
                         variables: [Any] = [],
                         session: URLSession = URLSession.shared,
                         completion: @escaping (Result<Profile, Error>) -> Void) {
        // Add body to mutate request
        let body: [String: Any] = ["mutation": mutationQuery, "variables": variables]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        session.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("\(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                NSLog("Data is nil")
                return
            }

            completion(self.decodeJSON(data: data))
        }.resume()
    }

    // MARK: - Helper Methods

    /// Method to decode JSON Data to usable Type
    /// - Parameter data: The JSON Data returned from the request
    /// - Returns: Either an Error or the Decoded object
    private func decodeJSON(data: Data) -> Result<Profile, Error> {
        do {
            // Decode data as ProfileQuery and pass the stored object of type Profile through completion
            let json = try JSONDecoder().decode(ProfileQuery.self, from: data)
            let profile = Array(json.data.values)[0]
            return .success(profile)
        } catch {
            NSLog("\(error)")
            return .failure(error)
        }
    }
}
