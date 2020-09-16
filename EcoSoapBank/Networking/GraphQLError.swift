//
//  GraphQLError.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/31/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum GraphQLError: Error {
    case noData
    case invalidData
    case noToken
    case unimplemented
    case backendMessages([String])
    case encodingError(Error)
    case decodingError(Error)
}
