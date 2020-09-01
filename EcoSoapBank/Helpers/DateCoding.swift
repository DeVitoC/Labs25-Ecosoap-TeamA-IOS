//
//  DateCoding.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/1/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    static let graphQL = JSONDecoder.DateDecodingStrategy.custom { decoder -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self).replacingOccurrences(of: "−", with: "-")
        print("Decoding date: \(dateString)")
        guard let date = ISO8601DateFormatter.shared.date(from: dateString) ??
            DateFormatter.yyyyMMdd.date(from: dateString) else {
                throw NSError(domain: "Unable to parse date", code: 0)
        }
        return date
    }
}

extension ISO8601DateFormatter {
    static let shared = ISO8601DateFormatter()
}

extension DateFormatter {
    static let yyyyMMdd = configure(DateFormatter()) {
        $0.dateFormat = "yyyy-MM-dd"
        $0.calendar = Calendar(identifier: .iso8601)
        $0.timeZone = TimeZone(secondsFromGMT: 0)
        $0.locale = Locale(identifier: "en_US_POSIX")
    }
}

extension Date {
    var iso8601String: String {
        ISO8601DateFormatter.shared.string(from: self)
    }
}
