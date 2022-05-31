//
//  JSONCoder+Ex.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Foundation

extension JSONEncoder.DateEncodingStrategy {
    static var `default`: JSONEncoder.DateEncodingStrategy {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.appDateFormat
        return JSONEncoder.DateEncodingStrategy.formatted(dateFormatter)
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static var `default`: JSONDecoder.DateDecodingStrategy {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.appDateFormat
        return JSONDecoder.DateDecodingStrategy.formatted(dateFormatter)
    }
}
