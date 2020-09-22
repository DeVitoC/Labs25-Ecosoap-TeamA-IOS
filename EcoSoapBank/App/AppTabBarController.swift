//
//  AppTabBarController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-02.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


/// The app's root level tab bar controller. Uses `BackgroundView` as its root view, and can dismiss any/all presented view controllers.
class AppTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configure(BackgroundView()) {
            view.constrainNewSubviewToSides($0)
            view.sendSubviewToBack($0)
        }
    }

    /// Recursively dismisses any view controllers currently being presented.
    func dismissAllPresentedViewControllers(onComplete: (() -> Void)?) {
        func dismissIfPresenting(on parent: UIViewController, onComplete: (() -> Void)?) {
            if let child = parent.presentedViewController {
                dismissIfPresenting(on: child, onComplete: {
                    parent.dismiss(animated: true, completion: onComplete)
                })
            } else {
                onComplete?()
            }
        }

        dismissIfPresenting(on: self, onComplete: onComplete)
    }
}
