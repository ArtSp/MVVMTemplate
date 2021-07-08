//
//  CategoriesListViewModel.swift
//  MVVMTemplate

import Foundation

class CategoriesListViewModel: ViewModel {

    @Published
    var state = CategoriesListState()
    private let service: MarketService

    init(service: MarketService) {
        self.service = service
    }
    
    func trigger(_ input: CategoriesListInput) {
        switch input {
        case .fetchCategories:
            fetchUsers()
        }
    }
    
    private func fetchUsers() {
        guard !state.isLoading else { return }
        state.isLoading = true
        
        service.getCategories()
            .map { categories in
                categories.map { AnyViewModel(CategoryDetailViewModel(category: $0, service: self.service)) }
            }
            .assertNoFailure()
            .sink(receiveCompletion: { _ in
                self.state.isLoading = false
            }, receiveValue: { categories in
                self.state.categories = categories
            })
            .store(in: &disposeBag)
    }
}
