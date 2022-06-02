//
//  ContentViewIO.swift
//  Created by Artjoms Spole on 02/06/2022.
//

extension ContentView: ViewModelView {
    
    struct ViewState {
        var masterViewModel: MasterView.ViewModel?
        var onboardingViewModel: OnboardingView.ViewModel?
    }
    
    enum ViewInput {
        case prepareMaster
        case prepareOnboarding
    }
}
