//
//  Products.swift
//  MVVMTemplate

import Foundation

extension API.Products {
    
    struct GetCategories: ModelTargetType, IsUnauthorized {
        typealias Response = CategoriesResponse
        var method: TargetMethod { .get }
        var path: String { "category/categories" }
    }
    
}
