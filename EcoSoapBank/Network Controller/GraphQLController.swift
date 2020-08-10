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
    let url = URL(string: "http://35.208.9.187:9094/ios-api-1/")!

    /// Method for GraphQL query requests
    /// - Parameters:
    ///   - query: The intended query as saved in string format
    ///   - session: The URLSession used for the request. By default this is URLSession.shared
    ///   - completion: Completion handler that passes back a Result of type Profile or Error
    func queryRequest(query: String, session: URLSession = URLSession.shared, completion: @escaping (Result<Profile, Error>) -> Void) {
        // The url request for the query
        var request = URLRequest(url: url)
        let body = ["query": query]

        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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

            do {
                // Decode data as ProfileQuery and pass the stored object of type Profile
                let profileJSON = try JSONDecoder().decode(ProfileQuery.self, from: data)
                let profile = Array(profileJSON.data.values)[0]
                completion(.success(profile))
            } catch {
                NSLog("\(error)")
                completion(.failure(error))
                return
            }
        }.resume()
    }
}
