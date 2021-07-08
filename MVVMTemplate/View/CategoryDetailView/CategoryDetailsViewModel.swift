//
//  UserDetailsViewModel.swift
//  MVVMTemplate

import Foundation

//MARK: - State

struct CategoryDetailState: Identifiable {
    var id: Category.ID { category.id }
    var category: Category
}

//MARK: - ViewModel

class CategoryDetailViewModel: ViewModel {

    @Published
    var state: CategoryDetailState
    private let service: MarketService

    init(category: Category, service: MarketService) {
        self.service = service
        self.state = CategoryDetailState(category: category)
    }

    func trigger(_ input: Never) { }
}
