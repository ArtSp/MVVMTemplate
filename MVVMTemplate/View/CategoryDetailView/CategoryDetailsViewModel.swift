//
//  UserDetailsViewModel.swift
//  MVVMTemplate

import Foundation

class CategoryDetailViewModel: ViewModel {

    @Published
    var state: CategoryDetailState
    private let service: MarketService

    init(
        category: Category,
        service: MarketService
    ) {
        self.service = service
        self.state = CategoryDetailState(category: category)
    }

    func trigger(
        _ input: Never
    ) { }
}
