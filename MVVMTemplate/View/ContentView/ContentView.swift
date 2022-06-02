//
//  ContentView.swift
//  Created by Artjoms Spole on 02/06/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @Preference(\.onboardingCompleted) var onboardingCompleted
    @Environment(\.locale) var locale
    
    var body: some View {
        if onboardingCompleted {
            Unwrap(viewModel.masterViewModel) {
                MasterView(viewModel: $0)
            } fallbackContent: {
                Color.clear.onAppear {
                    trigger(.prepareMaster)
                }
            }
        } else {
            Unwrap(viewModel.onboardingViewModel) {
                OnboardingView(viewModel: $0)
            } fallbackContent: {
                Color.clear.onAppear {
                    trigger(.prepareOnboarding)
                }
            }
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
