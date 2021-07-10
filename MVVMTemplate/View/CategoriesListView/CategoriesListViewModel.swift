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
                categories.map {
                    AnyViewModel(CategoryDetailViewModel(category: $0, service: self.service))
                }
            }
            .sink(receiveCompletion: { completion in
                self.state.isLoading = false
                if case let .failure(error) = completion {
                    self.state.showError(error)
                }
            }, receiveValue: { categories in
                self.state.categories = categories
            })
            .store(in: &disposeBag)
    }
}
