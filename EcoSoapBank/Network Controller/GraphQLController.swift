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
    ///   - type: The Model Type for the JSON Decoder to decode
    ///   - query: The intended query in string format
    ///   - variables: The variables to be passed in the request
    ///   - completion: Completion handler that passes back a Result of type Profile or Error
    func queryRequest<T: Decodable>(_ type: T.Type,
                                    query: String,
                                    variables: [String: Any] = [:],
                                    completion: @escaping (Result<T, Error>) -> Void) {
        // Add body to query request
        let body: [String: Any] = ["query": query, "variables": variables]
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
            guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let dataDict = jsonDict["data"] as? [String: Any],
                let returnType = Array(dataDict.keys).first,
                let returnData = dataDict[returnType] as? [String: Any],
                let methodType = Array(returnData.keys).first,
                let object: Any = returnData[methodType] as? [String: Any] ?? returnData[methodType] as? [Any],
                let objectData = try? JSONSerialization.data(withJSONObject: object, options: []) else {
                    return .failure(GraphQLError.noData)
            }
            let dict = try JSONDecoder().decode(T.self, from: objectData)
            
            return .success(dict)
        } catch {
            NSLog("\(error)")
            return .failure(error)
        }
    }
}

enum GraphQLError: Error {
    case noData
}
