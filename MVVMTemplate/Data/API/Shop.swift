//
//  Shop.swift
//  Created by Artjoms Spole on 03/06/2022.
//

extension API { enum Shop {} }

extension API.Shop {
    
    struct Products: ModelTargetType {
        typealias Response = API.Model.ProductResponse
        var path: String { "/products" }
        var method: TargetMethod { .get }
        var sampleData: Data { try! Response.fake.jsonData() }
    }
    
    struct Product: ModelTargetType {
        typealias Response = API.Model.Product
        var productId: ID
        var path: String { "/product/\(productId)" }
        var method: TargetMethod { .get }
        var sampleData: Data { try! Response.fake(id: productId).jsonData() }
    }
}
