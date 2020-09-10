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
@discardableResult
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

    func string(from formatter: DateFormatter = .default) -> String {
        formatter.string(from: self)
    }
}


extension TimeInterval {
    static func days(_ count: Int) -> TimeInterval {
        Double(count) * 86_400
    }
}


extension Measurement where UnitType == UnitMass {
    var string: String {
        
        guard let unitString = UserDefaults.massUnit else {
            return MeasurementFormatter.localUnits.string(from: self)
        }
        
        let unit: UnitMass
        
        // Create appropriate UnitMass from unit's symbol stored as string
        switch unitString {
        case "kg":
            unit = .kilograms
        case "lb":
            unit = .pounds
        default:
            unit = .pounds
        }
        
        return MeasurementFormatter.providedUnits.string(from: self.converted(to: unit))
    }
}

extension MeasurementFormatter {
    /// Defaults to appropriate units based on the users locale
    static let localUnits = configure(MeasurementFormatter()) {
        $0.numberFormatter.maximumFractionDigits = 2
    }
    
    /// For use when user has selected a certain unit
    static let providedUnits = configure(MeasurementFormatter()) {
        $0.numberFormatter.maximumFractionDigits = 2
        $0.unitOptions = .providedUnit
    }
}

extension NumberFormatter {
    static var forMeasurements: NumberFormatter {
        MeasurementFormatter.providedUnits.numberFormatter
    }

    static let forPercentage: NumberFormatter = configure(NumberFormatter()) {
        $0.numberStyle = .percent
        $0.allowsFloats = false
    }

    static let forDollars: NumberFormatter = configure(NumberFormatter()) {
        $0.numberStyle = .currency
        $0.currencyCode = "USD"
    }
}

extension Float {
    var percentString: String {
        NumberFormatter.forPercentage.string(from: NSNumber(value: self))!
    }
}

extension Int {
    var percentString: String {
        NumberFormatter.forPercentage.string(from: NSNumber(value: Double(self) * 0.01))!
    }
}

extension DateFormatter {
    static let `default`: DateFormatter = configure(DateFormatter()) {
        $0.dateStyle = .medium
        $0.timeStyle = .none
    }
}

/// Alternatively, `?<-`?
/// (`let x = self.point?.x ?<- CGPoint.zero` vs.
/// `let x = self.point?.x ??= CGPoint.zero`)
///
/// See `Optional.orSettingIfNil` to see use in practice.
infix operator ??=

extension Optional {
    /// If nil, sets wrapped value to the new value and then returns it. If non-nil, ignores the new value
    /// and simply returns the wrapped value.
    ///
    /// Similar to the nil-coalescing operator (`??`), but additionally sets the wrapped value if non-nil.
    mutating func orSettingIfNil(_ newValueIfNil: Wrapped) -> Wrapped {
        if self == nil { self = newValueIfNil }
        return self!
    }

    /// If nil, sets wrapped value to the new value and then returns it. If non-nil, ignores the new value
    /// and simply returns the wrapped value.
    ///
    /// Similar to the nil-coalescing operator (`??`), but additionally sets the left-hand value if non-nil.
    static func ??= (lhs: inout Wrapped?, rhs: Wrapped) -> Wrapped {
        lhs.orSettingIfNil(rhs)
    }
}

extension Result {
    var error: Failure? {
        if case .failure(let error) = self {
            return error
        } else {
            return nil
        }
    }
}
