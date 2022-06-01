//
//  MasterViewModelBase.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Combine

class MasterViewModelBase: ViewModelBase<MasterView.ViewState, MasterView.ViewInput> {
    
    func createDetailViewModel() -> DetailView.ViewModel? { fatalError(.notImplemented) }
    func loadData() { fatalError(.notImplemented) }
    
    init() {
        super.init(state: .init())
    }
    
    func openDetails() {
        state.detailViewModel = createDetailViewModel()
        
        state.detailViewModel
            .safelyUnwrapped { vm in
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
            loadData()
            
        case .openDetails:
            openDetails()
        }
    }
    
}

// TODO: Move to libs

extension Optional {
    func safelyUnwrapped(
        _ unwrappedAction: (Wrapped) -> Void
    ) {
        if let value = self { unwrappedAction(value) }
    }
}

extension Error {
    static var notImplemented: Error { String.notImplemented }
}

extension String {
    static var notImplemented: String { "Not Implemented!" }
}
