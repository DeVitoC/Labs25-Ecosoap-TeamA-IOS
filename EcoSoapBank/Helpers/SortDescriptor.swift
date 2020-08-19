//
//  SortDescriptor.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-19.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
// swiftlint:disable implicit_return

import Foundation


typealias SortDescriptor<Root> = (Root, Root) -> Bool


/// Builds a `SortDescriptor` function using the provided closure that,
/// given the values at the provided keypath, will determine whether two elements
/// should remain in the provided order.
func sortDescriptor<Root, Value>(
    keypath: KeyPath<Root, Value>,
    by areInIncreasingOrder: @escaping SortDescriptor<Value>
) -> SortDescriptor<Root> {
    return { item1, item2 in
        areInIncreasingOrder(item1[keyPath: keypath], item2[keyPath: keypath])
    }
}

/// Sorts in based on the provided keypath, either ascending or descending.
func sortDescriptor<Root, Value>(
    keypath: KeyPath<Root, Value>,
    ascending: Bool = true
) -> SortDescriptor<Root> where Value: Comparable {
    sortDescriptor(keypath: keypath,
                   by: ascending ? { $0 < $1 } : { $0 > $1 })
}

/// Combine multiple sort descriptors. For each descriptor, if it cannot determine a new order, the next descriptor is tried.
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
    func combine<Root>() -> SortDescriptor<Root> where Element == SortDescriptor<Root> {
        EcoSoapBank.combine(self)
    }
}
