//
//  GraphQLController.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 8/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import KeychainAccess
import OktaAuth

typealias ResultHandler<T> = (Result<T, Error>) -> Void

enum HTTPMethod: String {
    case post = "POST"
}

/// Class containing methods for communicating with GraphQL backend
class GraphQLController {

    // MARK: - Properties

    private let session: DataLoader
    private let url = URL(string: "http://35.208.9.187:9094/ios-api-1/")!
    private var token: String? { Keychain.Okta.getToken() }

    // Setting up the url request
    private lazy var request: URLRequest = {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }()

    // MARK: - INIT
    /// Allows GraphQLController to be set up with mock data for testing
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
    func queryRequest<T: Decodable, V: VariableType>(_ type: T.Type,
                                    query: String,
                                    variables: V,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        // Add body to query request
        let body = QueryInput(query: query, variables: variables)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return completion(.failure(error))
        }

        session.loadData(with: request) { data, _, error in
            if let error = error {
                NSLog("\(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                return completion(.failure(GraphQLError.noData))
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
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            guard let dataDict = jsonDict?["data"] as? [String: Any],
                let returnType = Array(dataDict.keys).first,
                let returnData = dataDict[returnType] as? [String: Any]
            else {
                if let errors = jsonDict?["errors"] as? [[String: Any]] {
                    let errorMessages = errors.compactMap {
                        $0["message"] as? String
                    }
                    errorMessages.forEach { NSLog($0) }
                    return .failure(GraphQLError.backendMessages(errorMessages))
                }
                return .failure(GraphQLError.invalidData)
            }

            var objectData: Data
            if returnType != "schedulePickup" {
                guard let methodType = Array(returnData.keys).first,
                    let object: Any = returnData[methodType] as? [String: Any] ?? returnData[methodType] as? [Any],
                    let objectDataUnwrapped = try? JSONSerialization.data(withJSONObject: object, options: [])
                    else {
                        return .failure(GraphQLError.invalidData)
                }
                objectData = objectDataUnwrapped
            } else {
                objectData = try JSONSerialization.data(withJSONObject: returnData, options: [])
            }

            let dict = try JSONDecoder().decode(T.self, from: objectData)
            
            return .success(dict)
        } catch {
            NSLog("\(error)")
            return .failure(error)
        }
    }

    // MARK: - Enums

    /// Enum describing the possible errors we can get back from
    private struct QueryInput<V: VariableType>: Encodable {
        let query: String
        let variables: V

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(query, forKey: .query)
            var variablesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .variables)
            try variablesContainer.encode(variables, forKey: .input)
        }

    }

    private enum CodingKeys: String, CodingKey {
        case query
        case variables
        case input
    }
}
    
enum GraphQLError: Error {
    case noData
    case invalidData
    case noToken
    case unimplemented
    case backendMessages([String])
}

/// Protocol to set conformance to possible input types for GraphQL query and mutation variables
protocol VariableType: Encodable {}

//extension Dictionary: VariableType where Key == GraphQLController.InputTypes, Value == String {}
extension Dictionary: VariableType where Key == String, Value == String {}
extension Pickup.ScheduleInput: VariableType {}

// MARK: - Data Providers

extension GraphQLController: UserDataProvider {
    func logIn(_ completion: @escaping ResultHandler<User>) {
        guard let token = self.token else {
            return completion(.failure(GraphQLError.noToken))
        }
        queryRequest(User.self,
                     query: GraphQLMutations.login,
                     variables: ["token": token],
                     completion: completion)
    }
}

extension GraphQLController: ImpactDataProvider {
    func fetchImpactStats(
        forPropertyID propertyID: String,
        _ completion: @escaping ResultHandler<ImpactStats>
    ) {
        // TODO: may need to add token later
        queryRequest(ImpactStats.self,
                     query: GraphQLQueries.impactStatsByPropertyId,
                     variables: ["propertyId": propertyID],
                     completion: completion)
    }
}

extension GraphQLController: PickupDataProvider {
    func fetchPickups(
        forPropertyID propertyID: String,
        _ completion: @escaping ResultHandler<[Pickup]>
    ) {
        // TODO: may need to add token later
        queryRequest([Pickup].self,
                     query: GraphQLQueries.pickupsByPropertyId,
                     variables: ["propertyId": propertyID],
                     completion: completion)
    }

    func schedulePickup(
        _ pickupInput: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>
    ) {
        // TODO: may need to add token later
        queryRequest(Pickup.ScheduleResult.self,
                     query: GraphQLQueries.impactStatsByPropertyId,
                     variables: pickupInput,
                     completion: completion)
    }
}

extension GraphQLController: PaymentDataProvider {
    func fetchPaymentsByPropertyId(_ completion: @escaping ResultHandler<[Payment]>) {
        completion(.failure(GraphQLError.unimplemented))
    }

    func makePayment(_ completion: @escaping ResultHandler<Payment>) {
        completion(.failure(GraphQLError.unimplemented))
    }
}
