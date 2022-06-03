//
//  OnboardingView.swift
//  Created by Artjoms Spole on 02/06/2022.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5).ignoresSafeArea()
            VStack {
                Text(viewModel.title)
                    .textStyle(.h1)
                Button("onboarding.button.complete") {
                    trigger(.completeOnboarding)
                }
                .padding()
            }
        }
    }
}

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static let viewModel = OnboardingViewModelFake().toAnyViewModel()
    static var previews: some View {
        OnboardingView(viewModel: viewModel)
    }
}
