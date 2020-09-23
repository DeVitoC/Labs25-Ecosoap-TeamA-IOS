//
//  UIStoryboard+Constants.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-05.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


extension UIStoryboard {
    /// Represents `Main.storyboard`.
    static let main = UIStoryboard(name: "Main", bundle: nil)

    /// Returns the storyboard with the same filename as the view controller's class name.
    static func `for`<VC: UIViewController>(
        _ viewController: VC.Type
    ) -> UIStoryboard {
        UIStoryboard(name: String(describing: VC.self), bundle: nil)
    }
}

extension UIViewController {
    /// A string representing the storyboard ID of this class. Defaults to the class name.
    class var storyboardID: String { String(describing: Self.self) }

    /// The storyboard representing this view controller. Defaults to using the class name.
    class func storyboard() -> UIStoryboard {
        UIStoryboard(name: self.storyboardID, bundle: nil)
    }

    /// Instantiate the initial view controller of this class's storyboard.
    class func fromStoryboard<VC: UIViewController>(
        with initializer: @escaping (NSCoder) -> VC?
    ) -> VC? {
        self.storyboard().instantiateInitialViewController(creator: initializer)
    }
}
