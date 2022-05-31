//
//  MasterView.swift
//  Created by Artjoms Spole on 31/05/2022.
//

extension MasterView: ViewModelView {
    struct ViewState {
        var detailViewModel: DetailView.ViewModel?
    }
    
    enum ViewInput {
        case loadData
    }
}

protocol MasterViewModel: ViewModelObject {
    
}
