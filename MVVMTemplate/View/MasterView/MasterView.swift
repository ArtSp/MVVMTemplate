//
//  MasterView.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import SwiftUI

struct MasterView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            Text("Hello, World!")
                .textStyle(.body1)
                .onAppear { viewModel.trigger(.loadData) }
                .navigation(item: $viewModel.state.detailViewModel) {
                    DetailView(viewModel: $0)
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
