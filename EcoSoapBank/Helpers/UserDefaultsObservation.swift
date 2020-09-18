//
//  DefaultsObservation.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/18/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import Combine
// swiftlint:disable block_based_kvo

/// A convenient object with which to observe a change to a default by way of
/// an onChange closure that is passed in on initialization.
/// - Example Usage:
///   ```
///   var observation = UserDefaults.$someDefault.observe { old, new in
///       print("Changed from: \(old) to \(new)")
///   }
///   ```
class UserDefaultsObservation: NSObject {
    
    // Create a KVOContext to identify the observer
    private static var context = 0
    
    /// The key to observe
    let key: Key
    
    /// Stores the closure that is called when the observed value is changed
    private var onChange: (Any, Any) -> Void
    
    /// This intializer stores the onChange closure, so be sure to break any reference
    /// cycles created by using `[weak self]`
    init(key: Key, onChange: @escaping (Any, Any) -> Void) {
        self.onChange = onChange
        self.key = key
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: key.rawValue, options: [.old, .new], context: &Self.context)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == key.rawValue, context == &Self.context else { return }
        onChange(change[.oldKey] as Any, change[.newKey] as Any)
    }
    
    /// Clean up the observer when this observation is de-initialized
    deinit {
        cancel()
    }
}

extension UserDefaultsObservation: Cancellable {
    func cancel() {
        UserDefaults.standard.removeObserver(self, forKeyPath: key.rawValue, context: nil)
    }

    func erasedToAnyCancellable() -> AnyCancellable {
        AnyCancellable(self)
    }
}
