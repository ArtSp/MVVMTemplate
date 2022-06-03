//
//  DummyJson.swift
//  Created by Artjoms Spole on 03/06/2022.
//

extension API { enum Request {} }

extension API.Request {
    struct Products: ModelTargetType {
        typealias Response = API.Model.Product
        var path: String { "/products" }
        var method: TargetMethod { .get }
        var sampleData: Data { (try? Response.fake.jsonData()) ?? Data() }
    }
}
