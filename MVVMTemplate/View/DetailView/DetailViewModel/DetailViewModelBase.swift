//
//  DetailViewModelBase.swift
//  Created by Artjoms Spole on 31/05/2022.
//

class DetailViewModelBase: ViewModelBase<DetailView.ViewState, DetailView.ViewInput>, DetailViewModel {
    
    init() {
        super.init(state: .init())
    }
    
    override func trigger(
        _ input: ViewInput
    ) {
        
    }
    
}
