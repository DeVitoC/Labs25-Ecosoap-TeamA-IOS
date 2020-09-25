//
//  Keychain+Okta.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/26/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import KeychainAccess
import OktaAuth

extension Keychain {
    /// A namespace for Okta related keychain properties and functions
    enum Okta {
        
        // MARK: - Public
        
        /// Whether or not there is a valid token and thus the user is logged in.
        static var isLoggedIn: Bool { (try? getToken()) != nil }
        
        /// Attempts to retrieve the token for the current Okta session
        /// - Throws: If there is no token or it is expired, throws a `LoginError`, `.notLoggedIn`
        /// - Returns: If there is a token, and it is not expired, that token is returned.
        static func getToken() throws -> String {
            if let token = keychain[tokenKey],
                let expiry = keychain[expiryKey],
                let date = dateFormatter.date(from: expiry),
                date > Date() {
                return token
            } else {
                throw LoginError.notLoggedIn
            }
        }
        
        /// Sets the token for the current Okta session as well as the expiry date.
        /// - Parameters:
        ///   - token: The token to set.
        ///   - expiresIn: The time in seconds that the token expires.
        static func setToken(_ token: String, expiresIn: TimeInterval) {
            keychain[tokenKey] = token
            
            let expiryDate = Date(timeIntervalSinceNow: expiresIn)
            keychain[expiryKey] = dateFormatter.string(from: expiryDate)
        }
        
        /// Removes the token from Keychain, used when logging out the user.
        static func removeToken() {
            keychain[tokenKey] = nil
            keychain[expiryKey] = nil
        }
        
        /// Used to update the expiry date for the current token.
        /// - Parameter date: The date the current token is set to expire.
        static func setExpiryDate(_ date: Date) {
            keychain[expiryKey] = dateFormatter.string(from: date)
        }
        
        // MARK: - Private
        
        private static let keychain = Keychain(service: "com.ecosoapbank.okta")
        private static let tokenKey = "token"
        private static let expiryKey = "expiry"
        
        private static let dateFormatter = configure(DateFormatter()) {
            $0.dateStyle = .full
            $0.timeStyle = .full
        }
    }
}
