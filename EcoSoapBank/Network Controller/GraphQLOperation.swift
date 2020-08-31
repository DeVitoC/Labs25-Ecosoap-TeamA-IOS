//
//  GraphQLOperation.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/31/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum GraphQLOperation {
    // Queries
    case impactStatsByPropertyId(id: String)
    case pickupsByPropertyId(id: String)
    case propertiesByUserId(id: String)
    case userById(id: String)
    
    // Mutations
    case login(token: String)
    case schedulePickup(input: Pickup.ScheduleInput)
    
    // MARK: - Public
    
    func getURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(self)
        
        return request
    }
    
    // MARK: - Private
    
    private var url: URL {
        URL(string: "http://35.208.9.187:9094/ios-api-1/")!
    }
    
    private var operationString: String {
        switch self {
        case .impactStatsByPropertyId:
            return GraphQLQueries.impactStatsByPropertyId
        case .pickupsByPropertyId:
            return GraphQLQueries.pickupsByPropertyId
        case .propertiesByUserId:
            return GraphQLQueries.propertiesByUserId
        case .userById:
            return GraphQLQueries.userById
        case .login:
            return GraphQLMutations.login
        case .schedulePickup:
            return GraphQLMutations.schedulePickup
        }
    }
}

// MARK: - Encoding

extension GraphQLOperation: Encodable {
    enum CodingKeys: String, CodingKey {
        case query
        case variables
        case input
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(operationString, forKey: .query)
        var variablesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .variables)
        
        switch self {
        case .impactStatsByPropertyId(let id), .pickupsByPropertyId(let id):
            try variablesContainer.encode(["propertyId": id], forKey: .input)
        case .propertiesByUserId(let id), .userById(let id):
            try variablesContainer.encode(["userId": id], forKey: .input)
        case .login(let token):
            try variablesContainer.encode(token, forKey: .input)
        case .schedulePickup(let input):
            try variablesContainer.encode(input, forKey: .input)
        }
    }
}
