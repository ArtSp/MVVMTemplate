//
//  ShopService.swift
//  Created by Artjoms Spole on 06/06/2022.
//

import Combine

// MARK: - ShopService

protocol ShopService {
    static var shared: Self { get }
    func getProducts() -> AnyPublisher<[Product], Error>
    func getProduct(_ id: ID) -> AnyPublisher<Product, Error>
}

// MARK: - ShopServiceImpl

final class ShopServiceImpl: ShopService {
    
    private init() {}
    
    static var shared: ShopServiceImpl {
        .init()
    }
    
    func getProducts() -> AnyPublisher<[Product], Error> {
        API.Shop.Products()
            .request()
            .map(\.products)
            .tryMap { try $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getProduct(
        _ id: ID
    ) -> AnyPublisher<Product, Error> {
        API.Shop.Product(productId: id)
            .request()
            .tryMap { try $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
}

// MARK: - ShopServiceFake

final class ShopServiceFake: ShopService {
    
    private init() {}
    
    static var shared: ShopServiceFake {
        .init()
    }
    func getProducts() -> AnyPublisher<[Product], Error> {
        API.Shop.Products()
            .fakeRequest()
            .map(\.products)
            .tryMap { try $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getProduct(
        _ id: ID
    ) -> AnyPublisher<Product, Error> {
        API.Shop.Product(productId: id)
            .fakeRequest()
            .tryMap { try $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
}
