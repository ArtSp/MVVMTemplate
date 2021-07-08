//
//  CategoriesListViewModel.swift
//  MVVMTemplate

import Foundation
import Combine

//MARK: - State

struct CategoriesListState {
    var categories = [AnyViewModel<CategoryDetailState, Never>]()
    var isLoading = false
}

//MARK: - Input

enum CategoriesListInput {
    case fetchCategories
}

//MARK: - ViewModel

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
