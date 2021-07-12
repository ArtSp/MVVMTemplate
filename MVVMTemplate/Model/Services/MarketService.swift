//
//  MarketService.swift
//  MVVMTemplate

import Foundation
import Combine

// MARK: - UserService
protocol MarketService {
    func getCategories() -> AnyPublisher<[Category], API.Error>
}

// MARK: - UserServiceImpl

final class MarketServiceImpl: MarketService {
    func getCategories() -> AnyPublisher<[Category], API.Error> {
        API.Products.GetCategories().request()
            .receive(on: DispatchQueue.main)
            .map { response in
                response.categoryItems.map {
                    Category(
                        name: $0.title,
                        items: $0.subcategories?.count ?? 0,
                        imageUrl: !$0.imageUrl.isNil ? URL(string: $0.imageUrl!) : nil
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - UserServiceFake

final class MarketServiceFake: MarketService {
    private static let responseTime = 0.5
    private static var categories = Category.fakes
    
    func getCategories() -> AnyPublisher<[Category], API.Error> {
        Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + Self.responseTime) {
                promise(.success(Self.categories))
            }
        }
        .eraseToAnyPublisher()
    }
}
