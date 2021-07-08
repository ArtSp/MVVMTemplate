//
//  MarketService.swift
//  MVVMTemplate

import Foundation
import Combine

// MARK: - UserService
protocol MarketService {
    func getCategories() -> AnyPublisher<[Category], Never>
}

// MARK: - UserServiceImpl

final class MarketServiceImpl: MarketService {
    func getCategories() -> AnyPublisher<[Category], Never> {
        API.Products.GetCategories().request()
            .receive(on: DispatchQueue.main)
            .map { response in
                response.categoryItems.map {
                    Category(name: $0.title, items: $0.subcategories?.count ?? 0)
                }
            }
            .assertNoFailure()
            .eraseToAnyPublisher()
    }
}

// MARK: - UserServiceFake

final class MarketServiceFake: MarketService {
    private var categories = [
        Category(name: "Outdoor & Garden", items: 12),
        Category(name: "Electronics", items: 18),
    ]
    
    func getCategories() -> AnyPublisher<[Category], Never> {
        Just(categories).eraseToAnyPublisher()
    }
}

