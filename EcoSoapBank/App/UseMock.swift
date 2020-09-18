//
//  UseMock.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


/// Represents either "live" or "mock" data to be used throughout the app.
///
/// May be expanded for adding further cases if you want to be able to use different combinations of mock data.
enum MockStatus {
    /// Use the "live" backend throughout the app.
    case live
    /// Use Lambda School's Okta backend and mock data. If `skipLogin` is true, Okta login will be skipped entirely.
    case useMock(skipLogin: Bool)
}


// MARK: - APP MOCK STATUS

/// Sets which set of data will be utilized throughout the app ("mock" or "live" data).
let mockStatus: MockStatus = .useMock(skipLogin: true)

// MARK: -


/// Whether or not mock data will be used throughout the app.
///
/// Simply "forwards" whether `mockStatus` is set to `MockStatus.useMock`
var useMock: Bool {
    if case .useMock = mockStatus {
        return true
    } else {
        return false
    }
}


/// Whether or not login should be skipped when using mock data.
///
/// Simply "forwards" the `skipLogin` parameter of the `MockStatus.useMock` case if `mockStatus` is set to it.
var skipLogin: Bool {
    if case .useMock(let skipLogin) = mockStatus {
        return skipLogin
    }
    return false
}
