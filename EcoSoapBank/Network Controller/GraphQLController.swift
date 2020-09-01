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

/// Class containing methods for communicating with GraphQL backend
class GraphQLController: UserDataProvider, ImpactDataProvider, PickupDataProvider {

    // MARK: - Properties

    private let session: DataLoader
    private var token: String? { Keychain.Okta.getToken() }

    // MARK: - Init
    
    /// Allows GraphQLController to be set up with mock data for testing
    init(session: DataLoader = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Public Methods
    
    // User
    
    func logIn(_ completion: @escaping ResultHandler<User>) {
        guard let token = self.token else {
            return completion(.failure(GraphQLError.noToken))
        }
        performOperation(.login(token: token), completion: completion)
    }
    
    func fetchUser(byID userID: String,
                   completion: @escaping ResultHandler<User>) {
        // TODO: may need to add token later
        performOperation(.userByID(id: userID), completion: completion)
    }
    
    // Impact
    
    func fetchImpactStats(forPropertyID propertyID: String,
                          _ completion: @escaping ResultHandler<ImpactStats>) {
        // TODO: may need to add token later
        performOperation(.impactStatsByPropertyID(id: propertyID), completion: completion)
    }
    
    // Pickups
    
    func fetchPickups(forPropertyID propertyID: String,
                      _ completion: @escaping ResultHandler<[Pickup]>) {
        // TODO: may need to add token later
        performOperation(.pickupsByPropertyID(id: propertyID), completion: completion)
    }
    
    func schedulePickup(_ pickupInput: Pickup.ScheduleInput,
                        completion: @escaping ResultHandler<Pickup.ScheduleResult>) {
        // TODO: may need to add token later
        performOperation(.schedulePickup(input: pickupInput), completion: completion)
    }
    
    func cancelPickup(_ pickupID: String, completion: @escaping ResultHandler<Pickup>) {
        // TODO: may need to add token later
        performOperation(.cancelPickup(id: pickupID), completion: completion)
    }
    
    // Properties
    
    func fetchProperties(forUserID userID: String,
                         completion: @escaping ResultHandler<[Property]>) {
        // TODO: may need to add token later
        performOperation(.propertiesByUserID(id: userID), completion: completion)
    }

    // MARK: - Private Methods
    
    /// Performs the desired GraphQLOperation
    /// - Parameters:
    ///   - operation: The GraphQLOperation to perform
    ///   - completion: A completion handler that will be called on a background thread
    ///                 with a Result containing either a decoded object of type T, or an Error
    private func performOperation<T: Decodable>(_ operation: GraphQLOperation,
                                                completion: @escaping ResultHandler<T>) {
        let request: URLRequest
        
        do {
            try request = operation.getURLRequest()
        } catch {
            completion(.failure(GraphQLError.encodingError(error)))
            return
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
            
            completion(self.decodeJSON(T.self, data: data))
        }
    }

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
}

