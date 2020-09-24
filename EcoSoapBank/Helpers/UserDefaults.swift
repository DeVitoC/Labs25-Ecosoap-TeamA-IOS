//
//  UserDefaults.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/18/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

/// This is where all of our user defaults can be stored. This setup uses a
/// property wrapper which makes it even simpler to get and set user defaults.
/// You can also observe changes on user defaults using a UserDefaultsObservation.
extension UserDefaults {
    @UserDefault(Key("massUnit")) static var massUnit: String?
}

// MARK: - Property Wrapper

/// This property wrapper simply gets and sets any allowable property list value
@propertyWrapper class UserDefault<T: PropertyListValue> {

    let key: Key

    var wrappedValue: T? {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? T }
        set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }
    
    var projectedValue: UserDefault<T> { self }
    
    init(_ key: Key) {
        self.key = key
    }
    
    // Allows observing changes through use of a closure. See "UserDefaultsObservation"
    func observe(change: @escaping (T?, T?) -> Void) -> UserDefaultsObservation {
        UserDefaultsObservation(key: key) { old, new in
            change(old as? T, new as? T)
        }
    }
}

// MARK: - Key

struct Key: RawRepresentable {
    let rawValue: String
}

extension Key: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}

// MARK: - Property-List Values

/// This protocol serves as a way to group types that are allowed to be stored in a property-list
/// It is a more type-safe way than simply using `Any`, as does UserDefaults.standard.value and .set
protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

// Every element must be a property-list type
extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}
