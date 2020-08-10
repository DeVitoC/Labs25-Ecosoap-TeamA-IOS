//
//  UtilityFunctions.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


/// Modifies the `value` passed in and returns the object modified using the passed-in closure. Returns a copy if a value type, but mutates the original if a reference type is provided. Useful for making the setup of an item more succinct and readable.
/// - Parameters:
///   - value: The item to be modified; can be just about anything
///   - change: A closure that takes in an inout copy of the provided `value`
/// - Throws: If `change` throws an error, this method will rethrow that error; otherwise no error can or will be thrown
/// - Returns: The `value` of type `T` with the modifications in `change` applied
public func configure<T>(
    _ value: T,
    with change: (inout T) throws -> Void
) rethrows -> T {
    var mutable = value
    try change(&mutable)
    return mutable
}


extension Date {
    init?(year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        guard let date = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        ).date
            else { return nil }

        self = date
    }

    func string(from formatter: DateFormatter) -> String {
        formatter.string(from: self)
    }
}


extension TimeInterval {
    static func days(_ count: Int) -> TimeInterval {
        Double(count) * 86_400
    }
}