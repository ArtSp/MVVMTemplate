//
//  OnboardingView.swift
//  Created by Artjoms Spole on 02/06/2022.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: ViewModel
    
    var screens: some View {
        TabView {
            ForEach((1...3), id: \.self) { i in
                VStack {
                    let systemImageName: String? = {
                        switch i {
                        case 1: return "paperplane.fill"
                        case 2: return "arrow.up.bin.fill"
                        case 3: return "ticket.fill"
                        default: return nil
                        }
                    }()
                    Unwrap(systemImageName) {
                        Image(systemName: $0)
                            .font(.largeTitle)
                            .padding()
                    }
                    Text("onboarding.screen\(i).title".localizedStringKey)
                }
                .foregroundColor(i == 2 ? .red : .blue)
            }
        }
        .tabViewStyle(.page)
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack {
                Text(viewModel.title)
                    .textStyle(.h1)
                
                screens
                    .frame(maxHeight: .infinity)
                
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
