//
//  OktaAuth+Shared.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import OktaAuth


extension OktaAuth {
    static var shared: OktaAuth { .ecoSoapBank }

    private static let lambda = OktaAuth(
        baseURL: URL(string: "https://auth.lambdalabs.dev/")!,
        clientID: "0oalwkxvqtKeHBmLI4x6",
        redirectURI: "labs://scaffolding/implicit/callback")

    private static let ecoSoapBank = OktaAuth(
        baseURL: URL(string: "https://dev-668428.okta.com")!,
        clientID: "0oapaqacafrGUTfKx4x6",
        redirectURI: "labs://scaffolding/implicit/callback")
}
