//
//  SceneDelegate.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 6/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import KeychainAccess
import UIKit
import OktaAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    var appCoordinator: AppFlowCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        appCoordinator = AppFlowCoordinator(window: window!)
        appCoordinator?.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        OktaAuth.shared.receiveCredentials(fromCallbackURL: url) { result in
            do {
                try result.get()
                let credentials = try OktaAuth.shared.credentialsIfAvailable()
                Keychain.Okta.setToken(credentials.accessToken, expiresIn: credentials.expiresIn)
                OktaAuth.success.send()
            } catch {
                OktaAuth.error.send(error)
            }
        }
    }
}
