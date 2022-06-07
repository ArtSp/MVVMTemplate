//
//  MasterView.swift
//  Created by Artjoms Spole on 31/05/2022.
//

extension MasterView: ViewModelView {
    
    struct ViewState {
        var products: [Product]?
        var detailViewModel: DetailView.ViewModel?
        var detailViewLastDispayDuration: TimeInterval?
        var useModalPresentation = true
        var isLoading = Set<LoadingContent>()
    }
    
    enum ViewInput {
        case loadData
        case openDetails(ID)
        case setModalDisplayMode(Bool)
    }
    
    enum LoadingContent {
        case products
    }
}
