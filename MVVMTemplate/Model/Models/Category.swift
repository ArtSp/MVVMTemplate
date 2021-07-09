//
//  Category.swift
//  MVVMTemplate

import Foundation

struct Category: Identifiable {
    var id = UUID()
    let name: String
    let items: Int
    let imageUrl: URL?
}

extension Category {
    static let fakes: [Category] = [
        Category(name: "Outdoor & Garden", items: 12, imageUrl: nil),
        Category(name: "Electronics", items: 18, imageUrl: nil)
    ]
}
