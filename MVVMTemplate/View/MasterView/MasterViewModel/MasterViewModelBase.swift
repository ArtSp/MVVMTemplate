//
//  MasterViewModelBase.swift
//  Created by Artjoms Spole on 31/05/2022.
//

class MasterViewModelBase: ViewModelBase<MasterView.ViewState, MasterView.ViewInput>, MasterViewModel {
    
    func loadData() { fatalError("notImplemented") }
    
    init() {
        super.init(state: .init())
    }
    
    override func trigger(
        _ input: ViewInput
    ) {
        switch input {
        case .loadData:
            loadData()
        }
    }
    
}
