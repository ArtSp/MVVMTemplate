//
//  DetailViewModel.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Combine
import Foundation

// MARK: - DetailViewModelBase

class DetailViewModelBase: ViewModelBase<DetailView.ViewState, DetailView.ViewInput> {
    
    let timerSubject = CurrentValueSubject<TimeInterval, Never>(.zero)
    var appearDate: Date?
    let productId: ID
    
    var shopService: ShopService { fatalError(.notImplemented) }
    
    init(
        productId: ID
    ) {
        self.productId = productId
        super.init(
            state: .init(
                displayTimePublisher: timerSubject.eraseToAnyPublisher()
            )
        )
        
        loadDetails()
    }
    
    override var bindings: [AnyCancellable] {
        [
            Timer.publish(every: 1, on: .main, in: .default)
                    .autoconnect()
                    .handleEvents(receiveOutput: { [weak self] date in
                        guard let appearDate = self?.appearDate else { return }
                        self?.timerSubject.send(date.timeIntervalSince(appearDate).rounded(.up))
                    })
                    .assignWeakly(to: \.state.date, on: self)
        ]
    }
    
    func loadDetails() {
        shopService.getProduct(productId)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.state.isLoading.insert(.productDetails) },
                receiveCompletion: { [weak self] _ in self?.state.isLoading.remove(.productDetails) }
            )
            .sinkResult(result: { [weak self] result in
                switch result {
                case let .success(product):
                    self?.state.selectedImage = product.images.first
                    self?.state.product = product
                    
                case let .failure(error):
                    error.showInContent()
                }
            })
            .store(in: &cancelables)
    }
    
    override func trigger(
        _ input: DetailView.ViewInput
    ) {
        switch input {
        case let .isVisible(visible):
            if visible && appearDate.isNil {
                appearDate = .init()
            }
            
        case let .selectedImage(imageUrl):
            state.selectedImage = imageUrl
        }
    }
    
}

// MARK: - DetailViewModelImpl

final class DetailViewModelImpl: DetailViewModelBase {
    
    override var shopService: ShopService {
        ShopServiceImpl.shared
    }
    
}

// MARK: - DetailViewModelFake

final class DetailViewModelFake: DetailViewModelBase {
    
    convenience init() {
        self.init(productId: 1)
    }
    
    override var shopService: ShopService {
        ShopServiceFake.shared
    }
    
}
