//
//  PrintJson.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/9/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

extension Data {
    /// Prints a pretty version of JSON data to the console. The JSON is printed in a valid
    /// format which makes it useful for copy-pasting into files for use as mock JSON in testing
    /// without using the network.
    func printJSON() {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print(String(decoding: jsonData, as: UTF8.self))
        } else {
            print("json data malformed")
        }
    }
}
