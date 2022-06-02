//
//  OnboardingView.swift
//  Created by Artjoms Spole on 02/06/2022.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.title)
            Button("onboarding.button.complete") {
                trigger(.completeOnboarding)
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
