//
//  Models.swift
//  Created by Artjoms Spole on 03/06/2022.
//

extension API.Model {
    
    struct Product: Codable {
        let title: String
    }
}

extension API.Model.Product {
    static let fake: Self = .init(title: "Test")
}
