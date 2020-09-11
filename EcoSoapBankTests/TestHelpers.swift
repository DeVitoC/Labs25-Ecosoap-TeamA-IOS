//
//  TestHelpers.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-11.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import EcoSoapBank
import SwiftUI


protocol HostingController {}

extension UIHostingController: HostingController {}

extension XCTestCase {
    func wait(for expectation: XCTestExpectation, timeout: TimeInterval = 5) {
        wait(for: [expectation], timeout: timeout)
    }
}


protocol KeyPathListable {
    var allKeyPaths: [PartialKeyPath<Self>] { get }
}

extension KeyPathListable {
    var allKeyPaths: [PartialKeyPath<Self>] {
        let mirror = Mirror(reflecting: self)

        return mirror.children
            .reduce(into: [PartialKeyPath<Self>]()) { keyPaths, labelValuePair in
                guard let key = labelValuePair.label else { return }
                keyPaths.append(\Self.[checkedMirrorDescendent: key] as PartialKeyPath)
        }
    }

    private subscript(checkedMirrorDescendent key: String) -> Any {
        Mirror(reflecting: self).descendant(key)!
    }
}

extension Property: KeyPathListable {}
