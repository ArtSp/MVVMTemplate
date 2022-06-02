//
//  MasterView.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import SwiftUI

struct MasterView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var detailViewLastDispayDuration: TimeInterval?
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.readSize { contentSize = $0 }
                
                VStack(spacing: 10) {
                    Unwrap(detailViewLastDispayDuration) { time in
                        Text("master.body.detailsDisplayDuration \(Int(time))")
                    }
                    
                    HStack {
                        Text("master.body.modal")
                        Toggle("master.body.modal", isOn: $viewModel.state.useModalPresentation)
                            .toggleStyle(.switch)
                            .labelsHidden()
                    }
                    
                    Button("master.navigation.openDetails") {
                        viewModel.trigger(.openDetails)
                    }
                    
                }
                .frame(maxWidth: .infinity, minHeight: contentSize.height)
                .scrollView(.vertical, showsIndicators: false)
            }
            .textStyle(.body1)
            .multilineTextAlignment(.center)
            .navigationTitle("master.navigation.title")
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
            .localePreview()
    }
}
