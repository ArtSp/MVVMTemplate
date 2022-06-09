//
//  ShopServiceTests.swift
//  Created by Artjoms Spole on 07/07/2021.
//

import XCTest
import Combine
@testable import MVVMTemplate

class ShopServiceTests: XCTestCase, CancelableStore {
    
    var shopService: ShopService!
    let asyncTimeout: TimeInterval = 10

    override func setUp() {
        super.setUp()
        shopService = ShopServiceImpl.shared
        continueAfterFailure = false
    }
    
    override func tearDown() {
        shopService = nil
        super.tearDown()
    }
    
    func test_getProducts() throws {
        let exp = expectation(description: "Products")
        defer { wait(for: [exp], timeout: asyncTimeout) }
        
        shopService.getProducts()
            .sinkResult { result in
                switch result {
                case let .success(products):
                    XCTAssert(!products.isEmpty)
                    
                case let .failure(error):
                    XCTAssertNoThrow {
                        throw error
                    }
                }
                exp.fulfill()
            }
            .store(in: &cancelables)
    }
    
    func test_getProduct() throws {
        let exp = expectation(description: "Product")
        defer { wait(for: [exp], timeout: asyncTimeout) }
        
        var requestProductId: ID!
        
        shopService.getProducts()
            .compactMap(\.first?.id)
            .handleEvents(receiveOutput: { requestProductId = $0 })
            .flatMap { self.shopService.getProduct($0) }
            .sinkResult { result in
                switch result {
                case let .success(product):
                    XCTAssertEqual(requestProductId, product.id)
                    
                case let .failure(error):
                    XCTAssertNoThrow {
                        throw error
                    }
                }
                exp.fulfill()
            }
            .store(in: &cancelables)
    }

}
