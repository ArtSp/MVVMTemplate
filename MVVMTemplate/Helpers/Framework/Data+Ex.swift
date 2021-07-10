//
//  Data+Ex.swift
//  MVVMTemplate

import Foundation

extension Data {
    enum Serialization {
        case json(String.Encoding), string(String.Encoding)
    }
    
    /// Returns data as serialized string
    ///
    /// Main use is to print out BE responses
    ///
    ///     print(response.data?.toString(serialization: .json(.utf8)) ?? "Empty")
    func toString(
        serialization: Serialization
    ) -> String? {
        switch serialization {
        case .json(let encoding):
            guard let json = try? JSONSerialization.jsonObject(with: self, options: []),
                  let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]),
                  let prettyPrintedString = NSString(data: data, encoding: encoding.rawValue) else {
                return nil
            }
            return prettyPrintedString as String
        case .string(let encoding):
            return String(data: self, encoding: encoding)
        }
    }
    
}
