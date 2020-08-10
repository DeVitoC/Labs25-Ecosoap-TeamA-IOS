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

class GraphQLController {
    let url = URL(string: "http://35.208.9.187:9094/ios-api-1/")!

    func queryRequest(query: String, session: URLSession = URLSession.shared, completion: @escaping (Result<Profile, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue

        let body = ["query": query]

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
                let profileJSON = try JSONDecoder().decode(ProfileQuery.self, from: data)
                let profile = Array(profileJSON.data.values)[0]
                completion(.success(profile))
            } catch {
                NSLog("\(error)")
                completion(.failure(error))
                return
            }
        }
    }
}
