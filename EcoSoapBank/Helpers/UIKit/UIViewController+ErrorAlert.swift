//
//  UIViewController+ErrorAlert.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-28.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


extension ErrorMessage {
    func alertController() -> UIAlertController {
        UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
    }
}


extension UIAlertAction {
    static var okay: UIAlertAction {
        UIAlertAction(title: "OK", style: .default, handler: nil)
    }
}


extension UIViewController {
    func presentAlert(
        for errorMessage: ErrorMessage,
        actions: [UIAlertAction] = [],
        animated: Bool = true,
        onComplete: (() -> Void)? = nil
    ) {
        if let error = errorMessage.error {
            NSLog("An error occurred: \(error)")
        } else {
            NSLog("An unknown error occurred.")
        }
        let alert = errorMessage.alertController()
        if actions.isEmpty {
            alert.addAction(.okay)
        } else {
            actions.forEach(alert.addAction(_:))
        }

        (self.presentedViewController ?? self).present(alert,
                                                       animated: animated,
                                                       completion: onComplete)
    }

    func presentAlert(
        for error: Error?,
        actions: [UIAlertAction] = [],
        animated: Bool = true,
        onComplete: (() -> Void)? = nil
    ) {
        self.presentAlert(for: ErrorMessage(error: error))
    }
}
