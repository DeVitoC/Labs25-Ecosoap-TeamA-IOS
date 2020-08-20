//
//  UserFacingError.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


/// An error that may be presented to the user.
protocol UserFacingError: Error {
    /// A short description of the error to be displayed to the user. Should be short and layperson-friendly.
    var userFacingDescription: String? { get }
}


enum MockError: Error {
    case shouldFail
}


extension Result where Failure == Error {
    static func mockFailure() -> Result<Success, Failure> {
        Result.failure(MockError.shouldFail)
    }
}
