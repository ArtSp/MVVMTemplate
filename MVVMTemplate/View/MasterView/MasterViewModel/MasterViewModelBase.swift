//
//  MasterViewModelBase.swift
//  Created by Artjoms Spole on 31/05/2022.
//

class MasterViewModelBase: ViewModelBase<MasterView.ViewState, MasterView.ViewInput> {
    
    func createDetailViewModel() -> DetailView.ViewModel { fatalError() }
    func loadData() { fatalError() }
    
    init() {
        super.init(state: .init())
    }
    
    override func trigger(
        _ input: ViewInput
    ) {
        switch input {
        case .loadData:
            loadData()
            
        case .openDetails:
            let vm = createDetailViewModel()
            state.detailViewModel = vm
        }
    }
    
}
