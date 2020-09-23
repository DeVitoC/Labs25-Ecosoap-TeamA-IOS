//
//  OktaAuth+Shared.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import OktaAuth
import Combine


extension OktaAuth {
    static var shared: OktaAuth { useMock ? lambda : ecoSoapBank }

    private static let lambda = OktaAuth(
        baseURL: URL(string: "https://auth.lambdalabs.dev/")!,
        clientID: "0oalwkxvqtKeHBmLI4x6",
        redirectURI: "labs://scaffolding/implicit/callback")

    private static let ecoSoapBank = OktaAuth(
        baseURL: URL(string: "https://dev-668428.okta.com")!,
        clientID: "0oapaqacafrGUTfKx4x6",
        redirectURI: "labs://scaffolding/implicit/callback")

    /// Publishes error if Okta login failed.
    static let error = PassthroughSubject<Error, Never>()
    /// Publishes `Void` if Okta login was successful.
    static let success = PassthroughSubject<Void, Never>()
}
