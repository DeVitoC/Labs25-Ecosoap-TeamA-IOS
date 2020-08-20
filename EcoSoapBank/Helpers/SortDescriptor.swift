//
//  SortDescriptor.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-19.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
// swiftlint:disable implicit_return
/// ^^ Disabled due to bug where SwiftLint requires both a non-explicit return
/// *and* that an opening curly brace not be alone on a new line,
/// which makes for one of two errors in the return value of `sortDescriptor(keypath:by:)`.
/// Including the return makes methods that return closures easier to read, so `implicit_return`
/// must be disabled.

import Foundation


typealias SortDescriptor<Root> = (Root, Root) -> Bool


/// Builds a `SortDescriptor` function using the provided closure that,
/// given the values at the provided keypath, will determine whether two elements
/// should remain in the provided order.
///
/// (Adapted from ObjC.io's *Advanced Swift*
/// ([see excerpt here](http://chris.eidhof.nl/post/sort-descriptors-in-swift/)).)
func sortDescriptor<Root, Value>(
    keypath: KeyPath<Root, Value>,
    by areInIncreasingOrder: @escaping SortDescriptor<Value>
) -> SortDescriptor<Root> {
    return { item1, item2 in
        areInIncreasingOrder(item1[keyPath: keypath], item2[keyPath: keypath])
    }
}

/// Sorts in based on the provided keypath, either ascending or descending.
///
/// (Adapted from ObjC.io's *Advanced Swift*
/// ([see excerpt here](http://chris.eidhof.nl/post/sort-descriptors-in-swift/)).)
func sortDescriptor<Root, Value>(
    keypath: KeyPath<Root, Value>,
    ascending: Bool = true
) -> SortDescriptor<Root> where Value: Comparable {
    sortDescriptor(keypath: keypath,
                   by: ascending ? { $0 < $1 } : { $0 > $1 })
}

/// Combine multiple sort descriptors. For each descriptor, if it cannot determine a new order,
/// the next descriptor is tried.
///
/// (Adapted from ObjC.io's *Advanced Swift*
/// ([see excerpt here](http://chris.eidhof.nl/post/sort-descriptors-in-swift/)).)
func combine<Root>(_ sortDescriptors: [SortDescriptor<Root>]) -> SortDescriptor<Root> {
    return { item1, item2 in
        for areInIncreasingOrder in sortDescriptors {
            if areInIncreasingOrder(item1, item2) {
                return true
            }
            if areInIncreasingOrder(item2, item1) {
                return false
            }
        }
        return false
    }
}

extension Array {
    /// Combine multiple sort descriptors. For each descriptor, if it cannot determine a new order,
    /// the next descriptor is tried.
    ///
    /// (Adapted from ObjC.io's *Advanced Swift*
    /// ([see excerpt here](http://chris.eidhof.nl/post/sort-descriptors-in-swift/)).)
    func combine<Root>() -> SortDescriptor<Root> where Element == SortDescriptor<Root> {
        EcoSoapBank.combine(self)
    }
}
