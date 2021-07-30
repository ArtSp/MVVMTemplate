//
//  UserDetailsViewModel.swift
//  MVVMTemplate

import Foundation

class CategoryDetailViewModel: ViewModel {

    @Published
    var state: CategoryDetailState
    private let marketService: MarketService

    init(
        category: Category,
        marketService: MarketService
    ) {
        self.marketService = marketService
        self.state = CategoryDetailState(category: category)
    }

    func trigger(
        _ input: Never
    ) { }
}

extension CategoryDetailViewModel {
    
    static func fake() -> CategoryDetailViewModel {
        .init(
            category: Category.fakes[0],
            marketService: MarketServiceFake()
        )
    }
}
