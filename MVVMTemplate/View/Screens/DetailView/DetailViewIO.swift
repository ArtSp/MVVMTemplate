//
//  DetailViewModel.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Combine

extension DetailView: ViewModelView {
    
    struct ViewState {
        var displayTimePublisher: AnyPublisher<TimeInterval, Never>
        var date: Date = .init()
        var product: Product?
        var isLoading = Set<LoadingContent>()
        var selectedImage: URL?
    }
    
    enum ViewInput {
        case isVisible(Bool)
        case selectedImage(URL)
    }
    
    enum LoadingContent {
        case productDetails
    }
}
