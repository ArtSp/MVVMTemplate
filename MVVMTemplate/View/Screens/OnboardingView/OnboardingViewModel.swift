//
//  OnboardingViewModel.swift
//  Created by Artjoms Spole on 02/06/2022.
//

// MARK: - OnboardingViewModelBase

class OnboardingViewModelBase: ViewModelBase<OnboardingView.ViewState, OnboardingView.ViewInput> {
    
    @Preference(\.onboardingCompleted) var onboardingCompleted
    
    init() {
        super.init(state: .init())
    }
    
    override func trigger(
        _ input: OnboardingView.ViewInput
    ) {
        switch input {
        case .completeOnboarding:
            onboardingCompleted = true
        }
    }
    
}

// MARK: - OnboardingViewModelImpl

final class OnboardingViewModelImpl: OnboardingViewModelBase { }

// MARK: - OnboardingViewModelFake

final class OnboardingViewModelFake: OnboardingViewModelBase { }
