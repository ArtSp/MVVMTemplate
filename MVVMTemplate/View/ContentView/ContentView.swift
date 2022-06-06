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
        .alert(item: $viewModel.state.showsAlert)
        .onAppear { updateViewModels() }
        .onChange(of: onboardingCompleted) { _ in updateViewModels() }
    }
    
    func updateViewModels() {
        trigger(.prepareFor(onboardingCompleted ? .master : .onboarding))
    }
}

// MARK: - Helpers

private extension View {
    @ViewBuilder
    func alert(
        item: Binding<ContentView.AlertModel?>
    ) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in if !value { item.wrappedValue = nil } }
        )
        
        self.alert(isPresented: isActive) {
            Alert(
                title: Text(item.wrappedValue?.title ?? ""),
                message: Text(item.wrappedValue?.message ?? "")
            )
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static let viewModel = ContentViewModelFake().toAnyViewModel()
    static var previews: some View {
        ContentView(viewModel: viewModel)
    }
}
