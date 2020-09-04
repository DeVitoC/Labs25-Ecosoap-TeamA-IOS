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
class GraphQLController: UserDataProvider, ImpactDataProvider, PickupDataProvider, PaymentDataProvider {

    // MARK: - Properties

    private let session: DataLoader
    private var token: String? { session.getToken() }

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

    func logOut() {
        session.removeToken()
    }
    
    func fetchUser(byID userID: String,
                   completion: @escaping ResultHandler<User>) {
        // TODO: may need to add token later
        performOperation(.userByID(id: userID), completion: completion)
    }
    
    func updateUserProfile(_ info: EditableProfileInfo,
                           completion: @escaping ResultHandler<User>) {
        // TODO: may need to add token later
        performOperation(.updateUserProfile(info: info), completion: completion)
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
        performOperation(.schedulePickup(input: pickupInput),
                         completion: completion,
                         decodingOptions: [.isNotNested: true])
    }
    
    func cancelPickup(_ pickupID: String, completion: @escaping ResultHandler<Pickup>) {
        // TODO: may need to add token later
        performOperation(.cancelPickup(id: pickupID), completion: completion)
    }
    
    // Payments
    
    func fetchPayments(forPropertyID propertyID: String, _ completion: @escaping ResultHandler<[Payment]>) {
        performOperation(.paymentsByPropertyID(id: propertyID), completion: completion)
    }

    func makePayment(_ paymentInput: Payment, completion: @escaping ResultHandler<Payment>) {
        completion(.failure(GraphQLError.unimplemented))
    }
    
    // Properties
    
    func fetchProperties(forUserID userID: String,
                         completion: @escaping ResultHandler<[Property]>) {
        // TODO: may need to add token later
        performOperation(.propertiesByUserID(id: userID), completion: completion)
    }
    
    func updateProperty(with info: EditablePropertyInfo,
                        completion: @escaping ResultHandler<Property>) {
        // TODO: may need to add token later
        performOperation(.updateProperty(info: info), completion: completion)
    }

    // MARK: - Private Methods
    
    /// Performs the desired GraphQLOperation
    /// - Parameters:
    ///   - operation: The GraphQLOperation to perform
    ///   - completion: A completion handler that will be called on a background thread
    ///                 with a Result containing either a decoded object of type T, or an Error
    private func performOperation<T: Decodable>(_ operation: GraphQLOperation,
                                                completion: @escaping ResultHandler<T>,
                                                decodingOptions: [CodingUserInfoKey: Any] = [:]) {
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
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .graphQL
            decoder.userInfo = decodingOptions
            
            do {
                let result = try decoder.decode(GraphQLResult<T>.self, from: data)
                
                if let object = result.object {
                    completion(.success(object))
                } else {
                    print(result.errorMessages)
                    completion(.failure(GraphQLError.backendMessages(result.errorMessages)))
                }
            } catch {
                completion(.failure(GraphQLError.decodingError(error)))
            }
        }
    }
}
