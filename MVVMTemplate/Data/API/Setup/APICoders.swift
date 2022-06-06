//
//  APICoders.swift
//  Created by Artjoms Spole on 03/06/2022.
//

import Foundation

extension JSONDecoder {
    static var apiDefault: JSONDecoder {
        JSONDecoder()
    }
    
    static func apiDefault(
        for object: Any
    ) -> JSONDecoder {
        let decoder = JSONDecoder.apiDefault
        if let customDateDecodable = object as? CustomDateDecodable {
            decoder.dateDecodingStrategy = customDateDecodable.dateDecodingStrategy
        }
        return decoder
    }
}

extension JSONEncoder {
    static var apiDefault: JSONEncoder {
        JSONEncoder()
    }
    
    static func apiDefault(
        for object: Any
    ) -> JSONEncoder {
        let encoder = JSONEncoder.apiDefault
        if let customDateEncodable = object as? CustomDateEncodable {
            encoder.dateEncodingStrategy = customDateEncodable.dateEncodingStrategy
        }
        return encoder
    }
    
}

extension Encodable {
    
    func jsonData(
        encoder: JSONEncoder
    ) throws -> Data {
        try encoder.encode(self)
    }
    
    func jsonData(
    ) throws -> Data {
        try jsonData(encoder: .apiDefault)
    }
}

extension Decodable {
    init(
        jsonFileName: String
    ) throws {
        guard let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") else {
            throw "File not found!"
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        self = try JSONDecoder.apiDefault.decode(Self.self, from: data)
    }
}
