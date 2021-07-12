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
                response.categoryItems.map { $0.toDomain() }
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
