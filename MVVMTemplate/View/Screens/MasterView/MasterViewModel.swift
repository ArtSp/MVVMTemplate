//
//  MasterViewModel.swift
//  Created by Artjoms Spole on 31/05/2022.
//
import CombineMoya
import Combine

// MARK: - MasterViewModelBase

class MasterViewModelBase: ViewModelBase<MasterView.ViewState, MasterView.ViewInput> {
    typealias LoadingContent = MasterView.LoadingContent
    
    var shopService: ShopService { fatalError(.notImplemented) }
    func createDetailViewModel(productId: ID) -> DetailView.ViewModel? { fatalError(.notImplemented) }
    
    init() {
        super.init(state: .init())
        
        play()
    }
    
    func play() {
        Task {
            do {
                let text1 = try await getText(after: 3)
                print(text1)
                let text2 = try await getText(after: 2)
                print(text2)
                let text3 = try await getText(after: 1)
                print(text3)
            } catch {
                print(error)
            }
        }
    }
    
    func getText(
        after delay: TimeInterval
    ) async throws -> String {
        try await Task.sleep(seconds: delay)
        return "🤡 Hola! \(delay) seconds passed"
    }
    
    func openDetails(
        productId: ID
    ) {
        state.detailViewModel = createDetailViewModel(productId: productId)
        
        state.detailViewModel.safelyUnwrapped { vm in
            vm.displayTimePublisher
                .sink(receiveValue: { [weak self] displayTime in
                    self?.state.detailViewLastDispayDuration = displayTime
                })
                .store(in: &vm.cancelables)
        }
    
    }
    
    func loadProducts() {
        shopService.getProducts()
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.state.isLoading.insert(.products) },
                receiveCompletion: { [weak self] _ in self?.state.isLoading.remove(.products) }
            )
            .sinkResult(result: { [weak self] result in
                switch result {
                case let .success(products):
                    self?.state.products = products
                    
                case let .failure(error):
                    error.showInContent()
                }
            })
            .store(in: &cancelables)
    }
    
    override func trigger(
        _ input: ViewInput
    ) {
        switch input {
        case .loadData:
            loadProducts()
            
        case let .openDetails(productId):
            openDetails(productId: productId)
            
        case let .setModalDisplayMode(useModal):
            state.useModalPresentation = useModal
        }
    }
    
}

// MARK: - MasterViewModelImpl

final class MasterViewModelImpl: MasterViewModelBase {
    
    override var shopService: ShopService {
        ShopServiceImpl.shared
    }
    
    override func createDetailViewModel(
        productId: ID
    ) -> DetailView.ViewModel {
        DetailViewModelImpl(productId: productId).toAnyViewModel()
    }
    
}

// MARK: - MasterViewModelFake

final class MasterViewModelFake: MasterViewModelBase {
    
    override var shopService: ShopService {
        ShopServiceFake.shared
    }
    
    override func createDetailViewModel(
        productId: ID
    ) -> DetailView.ViewModel {
        DetailViewModelFake(productId: productId).toAnyViewModel()
    }
    
}

extension Task where Success == Never, Failure == Never {
    static func sleep(
        seconds: TimeInterval
    ) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
