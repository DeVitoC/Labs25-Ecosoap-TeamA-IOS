//
//  AppDelegate.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 6/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import SwiftUI
import Stripe


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Stripe.setDefaultPublishableKey("pk_test_51HLF1UKa1YnGlDrRQFihKS3jQGrbOCryI29gKBdXLJUt3lWKaKTRTjhBXxsIFV4xQiCh15gYM4PiJwQaaiN6BiHk00blUGhoiG")
        setUpAppAppearance()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        UISceneConfiguration(name: "Default Configuration",
                             sessionRole: connectingSceneSession.role)
    }

    private func setUpAppAppearance() {
        configure(UITabBar.appearance()) {
            $0.tintColor = .esbGreen
            $0.backgroundColor = .downyBlue
        }

        configure(UITableView.appearance()) {
            $0.backgroundColor = UIColor.esbGreen.orInverse().withAlphaComponent(0.3)
        }

        configure(UITableViewCell.appearance()) {
            $0.backgroundColor = .clear
        }

        configure(UINavigationBar.appearance()) { nav in
            nav.standardAppearance = configure(UINavigationBarAppearance()) {
                $0.backgroundImage = UIImage.navBar.withAlpha(0.4)
                $0.backgroundColor = .systemBackground
                $0.backgroundEffect = UIBlurEffect(style: .systemMaterial)
                $0.titleTextAttributes = [
                    .font: UIFont.navBarInlineTitle,
                    .foregroundColor: UIColor.label
                ]
            }
            nav.compactAppearance = configure(UINavigationBarAppearance()) {
                $0.backgroundImage = UIImage.navBar.withAlpha(0.4)
                $0.backgroundColor = .systemBackground
                $0.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
                $0.titleTextAttributes = [
                    .font: UIFont.navBarInlineTitle,
                    .foregroundColor: UIColor.label
                ]
            }
            nav.scrollEdgeAppearance = configure(UINavigationBarAppearance()) {
                $0.configureWithTransparentBackground()
                $0.largeTitleTextAttributes = [
                    .font: UIFont.navBarLargeTitle,
                ]
            }
        }
    }
}
