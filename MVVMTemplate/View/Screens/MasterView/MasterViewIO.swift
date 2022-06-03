//
//  MasterView.swift
//  Created by Artjoms Spole on 31/05/2022.
//

extension MasterView: ViewModelView {
    
    struct ViewState {
        var detailViewModel: DetailView.ViewModel?
        var detailViewLastDispayDuration: TimeInterval?
        var useModalPresentation = true
    }
    
    enum ViewInput {
        case loadData
        case openDetails
    }
}
