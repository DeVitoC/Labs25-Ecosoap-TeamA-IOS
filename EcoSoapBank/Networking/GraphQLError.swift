//
//  GraphQLError.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/31/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum GraphQLError: LocalizedError {
    case noData
    case invalidData
    case noToken
    case unimplemented
    case backendMessages([String])
    case encodingError(Error)
    case decodingError(Error)

    var errorDescription: String? {
        let dataMessage = "Error with data"
        let unknown = "Unknown error"
        switch self {
        case .noData, .invalidData:
            return dataMessage
        case .noToken:
            return "Error with sign-in info"
        case .backendMessages:
            return "Server error"
        case .encodingError(let other), .decodingError(let other):
            return (other as? LocalizedError)?.errorDescription ?? dataMessage
        default:
            return unknown
        }
    }

    var recoverySuggestion: String? {
        "Try again a little later. Contact us if this happens repeatedly."
    }
}
