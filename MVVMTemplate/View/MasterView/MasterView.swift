//
//  MasterView.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import SwiftUI

struct MasterView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var detailViewLastDispayDuration: TimeInterval?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Unwrap(detailViewLastDispayDuration) { time in
                    Text("Detail screen last time was opened for:\n\(Int(time)) seconds")
                }
                
                HStack {
                    Text("Modal")
                    Toggle("Modal", isOn: $viewModel.state.useModalPresentation)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
                
                Button("OpenDetails") {
                    viewModel.trigger(.openDetails)
                }
                
            }
            .textStyle(.body1)
            .multilineTextAlignment(.center)
            .navigationTitle("Master View")
            .if(viewModel.useModalPresentation) { view in
                view.fullScreenCover(item: $viewModel.state.detailViewModel) {
                    DetailView(viewModel: $0, isModal: viewModel.useModalPresentation)
                }
            } else: { view in
                view.navigation(item: $viewModel.state.detailViewModel) {
                    DetailView(viewModel: $0, isModal: viewModel.useModalPresentation)
                }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear { viewModel.trigger(.loadData) }
        .onChange(of: viewModel.detailViewLastDispayDuration) { newValue in
            withAnimation(.easeIn) {
                detailViewLastDispayDuration = newValue
            }
        }
    }
}

// MARK: - Preview

struct MasterView_Previews: PreviewProvider {
    static let viewModel = MasterViewModelFake().toAnyViewModel()
    static var previews: some View {
        MasterView(viewModel: viewModel)
    }
}
