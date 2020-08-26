//
//  UIStoryboard+Constants.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-05.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)

    static func `for`<VC: UIViewController>(
        _ viewController: VC.Type
    ) -> UIStoryboard {
        UIStoryboard(name: String(describing: VC.self), bundle: nil)
    }
}

extension UIViewController {
    class var storyboardID: String { String(describing: Self.self) }

    class func storyboard() -> UIStoryboard {
        UIStoryboard(name: self.storyboardID, bundle: nil)
    }

    class func fromStoryboard<VC: UIViewController>(
        with initializer: @escaping (NSCoder) -> VC?
    ) -> VC? {
        self.storyboard().instantiateInitialViewController(creator: initializer)
    }
}
