//
//  MasterViewModel.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Combine

// MARK: - MasterViewModelBase

class MasterViewModelBase: ViewModelBase<MasterView.ViewState, MasterView.ViewInput> {
    
    func createDetailViewModel() -> DetailView.ViewModel? { fatalError(.notImplemented) }
    
    init() {
        super.init(state: .init())
    }
    
    func openDetails() {
        state.detailViewModel = createDetailViewModel()
        
        state.detailViewModel.safelyUnwrapped { vm in
            vm.displayTimePublisher
                .sink(receiveValue: { [weak self] displayTime in
                    self?.state.detailViewLastDispayDuration = displayTime
                })
                .store(in: &vm.cancelables)
        }
    }
    
    override func trigger(
        _ input: ViewInput
    ) {
        switch input {
        case .loadData:
            print(String.notImplemented)
            
        case .openDetails:
            openDetails()
        }
    }
    
}

// MARK: - MasterViewModelImpl

final class MasterViewModelImpl: MasterViewModelBase {
    
    override func createDetailViewModel() -> DetailView.ViewModel {
        DetailViewModelImpl().toAnyViewModel()
    }
    
}

// MARK: - MasterViewModelFake

final class MasterViewModelFake: MasterViewModelBase {
    
    override func createDetailViewModel() -> DetailView.ViewModel {
        DetailViewModelFake().toAnyViewModel()
    }
    
}
