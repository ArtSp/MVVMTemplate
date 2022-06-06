//
//  Models.swift
//  Created by Artjoms Spole on 03/06/2022.
//

extension API.Model {
    
    struct ProductResponse: Codable {
        let products: [Product]
        let total: Int
        let skip: Int
        let limit: Int
    }
    
    struct Product: Codable {
        let id: ID
        let title: String
        let description: String
        let price: Price
        let discountPercentage: Float
        let rating: Float
        let stock: Count
        let brand: String
        let category: String
        let thumbnail: String
        let images: [String]
    }
}

extension API.Model.ProductResponse {
    static let fake: Self = try! .init(jsonFileName: "ProductResponse")
}

extension API.Model.Product {
    static func fake(
        id: ID
    ) -> Self {
        let fakes = API.Model.ProductResponse.fake.products
        return fakes.first(where: { $0.id == id }) ?? fakes.first!
    }
}
