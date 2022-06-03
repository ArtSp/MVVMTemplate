//
//  ContentViewModel.swift
//  Created by Artjoms Spole on 02/06/2022.
//

// MARK: - ContentViewModelBase

class ContentViewModelBase: ViewModelBase<ContentView.ViewState, ContentView.ViewInput> {
    
    @Preference(\.onboardingCompleted) var onboardingCompleted
    
    func createMasterViewModel() -> MasterView.ViewModel? { fatalError(.notImplemented) }
    func createOnboardingViewModel() -> OnboardingView.ViewModel? { fatalError(.notImplemented) }
    
    init() {
        super.init(state: .init())
    }
    
    func setViewModel(
        for vmType: ContentView.ViewModelType
    ) {
        switch vmType {
        case .master:
            state.masterViewModel = createMasterViewModel()
            
        case .onboarding:
            state.onboardingViewModel = createOnboardingViewModel()
            
        }
    }
    
    override func trigger(
        _ input: ContentView.ViewInput
    ) {
        switch input {
        case let .prepareFor(vmType):
            setViewModel(for: vmType)
        }
    }
    
}

// MARK: - ContentViewModelImpl

final class ContentViewModelImpl: ContentViewModelBase {
    
    override func createMasterViewModel() -> MasterView.ViewModel {
        MasterViewModelImpl().toAnyViewModel()
    }
    
    override func createOnboardingViewModel() -> OnboardingView.ViewModel? {
        OnboardingViewModelImpl().toAnyViewModel()
    }
    
}

// MARK: - ContentViewModelFake

final class ContentViewModelFake: ContentViewModelBase {
    
    override func createMasterViewModel() -> MasterView.ViewModel {
        MasterViewModelFake().toAnyViewModel()
    }
    
    override func createOnboardingViewModel() -> OnboardingView.ViewModel? {
        OnboardingViewModelFake().toAnyViewModel()
    }
    
}
