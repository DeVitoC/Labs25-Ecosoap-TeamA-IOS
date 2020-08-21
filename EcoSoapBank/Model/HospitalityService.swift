/* GRAPHQL SCHEMA (as of 2020-08-07 15:35)
 enum HospitalityService {
     BOTTLES
     LINENS
     OTHER
     PAPER
     SOAP
 }
 */

import Foundation

enum HospitalityService: String, Decodable, CaseIterable, Identifiable {
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
