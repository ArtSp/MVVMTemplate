//
//  DetailViewModel.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Combine

extension DetailView: ViewModelView {
    
    struct ViewState {
        var displayTimePublisher: AnyPublisher<TimeInterval, Never>
        var date: Date = .init()
    }
    
    enum ViewInput {
        case isVisible(Bool)
    }
}
