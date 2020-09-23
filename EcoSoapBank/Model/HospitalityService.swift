//
//  HospitalityService.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 8/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum HospitalityService: String, Codable, CaseIterable, Identifiable, Equatable {
    case bottles = "BOTTLES"
    case linens = "LINENS"
    case other = "OTHER"
    case paper = "PAPER"
    case soap = "SOAP"

    var id: String { rawValue }

    static let displayOptions: [HospitalityService] = [
        .soap, .bottles, .linens, .paper, .other
    ]
}
