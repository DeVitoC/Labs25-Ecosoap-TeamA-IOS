//
//  GraphQLResult.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/2/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

/// A container for decoding the result of a GraphQL query or mutation
struct GraphQLResult<T: Decodable>: Decodable {
    
    /// The decoded object, if present
    let object: T?
    /// A list of error messages from the GraphQL server. There can be errors even if an object
    /// was successfully decoded.
    let errorMessages: [String]
    
    enum CodingKeys: String, CodingKey {
        case data
        case errors
    }
    
    struct Error: Decodable {
        let message: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // This logic lets the decoder decode objects that are nested at two
        // different levels in the JSON using the `isNotNested` CodingUserInfoKey
        if let isNotNested = decoder.userInfo[.isNotNested] as? Bool, isNotNested == true {
            let dataDict = try container.decodeIfPresent([String: T].self, forKey: .data)
            self.object = dataDict?.values.first
        } else {
            let dataDict = try container.decodeIfPresent([String: [String: T]].self, forKey: .data)
            self.object = dataDict?.values.first?.values.first
        }
        
        var errorMessages: [String] = []
        
        let errors = try container.decodeIfPresent([Error].self, forKey: .errors)
        if let errors = errors {
            errorMessages.append(contentsOf: errors.map { $0.message })
        }
        
        self.errorMessages = errorMessages
    }
}

extension CodingUserInfoKey {
    /// Specified in cases where the object being decoded is not nested in a dictionary.
    /// - Example: When scheduling a `Pickup`, `Pickup.ScheduleResult` is not nested
    /// but instead is the top level value for the key "schedulePickup"
    static let isNotNested = CodingUserInfoKey(rawValue: "isNotNested")!
}
