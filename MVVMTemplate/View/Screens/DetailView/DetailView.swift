//
//  DetailView.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.locale) var locale
    @Environment(\.isPresented) var isPresented
    @Environment(\.dismiss) var dismiss
    var isModal: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy HH:mm:ss"
        formatter.locale = locale
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("detail.body.date")
                .textStyle(.h1)
            Text(dateFormatter.string(from: viewModel.date))
                .textStyle(.body1)
            Button("detail.navigation.dismiss") {
                dismiss()
            }
            .isHidden(!isModal)
        }
        .multilineTextAlignment(.center)
        .navigationTitle("detail.navigation.title")
        .onAppear { viewModel.trigger(.isVisible(isPresented)) }
        .onChange(of: isPresented) { isPresented in
            viewModel.trigger(.isVisible(isPresented))
        }
    }
}

// MARK: - Preview

struct DetailView_Previews: PreviewProvider {
    static let viewModel = DetailViewModelFake().toAnyViewModel()
    static var previews: some View {
        DetailView(viewModel: viewModel, isModal: true)
            .localePreview()
    }
}
