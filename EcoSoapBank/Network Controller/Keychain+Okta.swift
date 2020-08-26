//
//  Keychain+Okta.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/26/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import KeychainAccess

extension Keychain {
    enum Okta {
        // MARK: - Public
        
        static var isLoggedIn: Bool { getToken() != nil }
        
        static func getToken() -> String? {
            if let token = keychain[tokenKey],
               let expiry = keychain[expiryKey],
               let date = dateFormatter.date(from: expiry),
               date > Date() {
                return token
            } else {
                NotificationCenter.default.post(name: .oktaAuthenticationExpired, object: nil)
                return nil
            }
        }
        
        static func setToken(_ token: String, expiresIn: TimeInterval) {
            keychain[tokenKey] = token
            
            let expiryDate = Date(timeIntervalSinceNow: expiresIn)
            keychain[expiryKey] = dateFormatter.string(from: expiryDate)
        }
        
        static func removeToken() {
            keychain[tokenKey] = nil
            keychain[expiryKey] = nil
        }
        
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
