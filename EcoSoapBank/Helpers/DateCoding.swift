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
        guard let date = ISO8601DateFormatter.full.date(from: dateString) ??
            ISO8601DateFormatter.short.date(from: dateString) else {
                throw NSError(domain: "Unable to parse date", code: 0)
        }
        return date
    }
}

extension ISO8601DateFormatter {
    static let full = ISO8601DateFormatter()
    static let short = configure(ISO8601DateFormatter()) {
        $0.formatOptions = [.withFullDate, .withDashSeparatorInDate]
    }
}

extension Date {
    var iso8601String: String {
        ISO8601DateFormatter.full.string(from: self)
    }
}
