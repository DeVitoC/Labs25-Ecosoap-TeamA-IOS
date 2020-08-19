//
//  SortDescriptor.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-19.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
// swiftlint:disable implicit_return

import Foundation


enum Sort {
    typealias Descriptor<Root> = (Root, Root) -> Bool

    func descriptor<Root, Value>(
        keypath: KeyPath<Root, Value>,
        ascending: Bool = true,
        by compare: @escaping (Value, Value) -> Bool
    ) -> Sort.Descriptor<Root> {
        return { item1, item2 in
            compare(item1[keyPath: keypath], item2[keyPath: keypath])
        }
    }
}
