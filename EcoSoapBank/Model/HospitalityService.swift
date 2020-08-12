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

enum HospitalityService: String {
    case bottles = "BOTTLES"
    case linens = "LINENS"
    case other = "OTHER"
    case paper = "PAPER"
    case soap = "SOAP"
}
