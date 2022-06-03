//
//  ContentView.swift
//  Created by Artjoms Spole on 02/06/2022.
//

import SwiftUI

/// Application main content view
struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @Preference(\.onboardingCompleted) var onboardingCompleted
    @Environment(\.locale) var locale
    
    var body: some View {
        ZStack {
            if onboardingCompleted {
                Unwrap(viewModel.masterViewModel) {
                    MasterView(viewModel: $0)
                }
            } else {
                Unwrap(viewModel.onboardingViewModel) {
                    OnboardingView(viewModel: $0)
                }
            }
        }
        .onAppear { updateViewModels() }
        .onChange(of: onboardingCompleted) { _ in updateViewModels() }
    }
    
    func updateViewModels() {
        trigger(.prepareFor(onboardingCompleted ? .master : .onboarding))
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static let viewModel = ContentViewModelFake().toAnyViewModel()
    static var previews: some View {
        ContentView(viewModel: viewModel)
    }
}
