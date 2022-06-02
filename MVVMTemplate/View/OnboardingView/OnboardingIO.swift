//
//  OnboardingIO.swift
//  Created by Artjoms Spole on 02/06/2022.
//

extension OnboardingView: ViewModelView {
    
    struct ViewState {
        var title: String = "Hola!"
    }
    
    enum ViewInput {
        case completeOnboarding
    }
}
