//
//  CategoriesListViewModel.swift
//  MVVMTemplate

import Foundation

class CategoriesListViewModel: ViewModel {

    @Published
    var state = CategoriesListState()
    private let marketService: MarketService
    private let localStorageService: LocalStorageService

    init(
        marketService: MarketService,
        localStorageService: LocalStorageService
    ) {
        self.marketService = marketService
        self.localStorageService = localStorageService
        
        localStorageService.getProfileImage()
            .sink(receiveValue: {
                self.state.profileImage = $0
            })
            .store(in: &cancelables)
    }
    
    func trigger(
        _ input: CategoriesListInput
    ) {
        switch input {
        case .fetchCategories:
            fetchUsers()
            
        case .showImagePicker:
            state.isShowingImagePicker = true
            
        case let .selectedProfileImage(image):
            localStorageService.setProfileImage(image)
        }
    }
    
    private func fetchUsers() {
        guard !state.isLoading else { return }
        state.isLoading = true
        
        marketService.getCategories()
            .map { categories in
                categories.map {
                    AnyViewModel(CategoryDetailViewModel(category: $0, marketService: self.marketService))
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
            .store(in: &cancelables)
    }
}

extension CategoriesListViewModel {
    
    static func fake() -> CategoriesListViewModel {
        .init(
            marketService: MarketServiceFake(),
            localStorageService: LocalStorageServiceFake()
        )
    }
}
