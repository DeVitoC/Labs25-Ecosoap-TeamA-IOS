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


/// Because UIHostingController is generic, it is difficult to use in some cases. This protocol allows tests to assert that a given `UIViewController` is also some `UIHostingController`.
protocol HostingController {}

extension UIHostingController: HostingController {}


extension XCTestCase {
    /// Waits for the test to fulfill a single expectation within a specified time.
    /// - Parameters:
    ///   - expectation: An expectation that must be fulfilled.
    ///   - timeout: The number of seconds within which all expectations must be fulfilled.
    func wait(for expectation: XCTestExpectation, timeout: TimeInterval = 5) {
        wait(for: [expectation], timeout: timeout)
    }
}
