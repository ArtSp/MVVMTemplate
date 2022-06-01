//
//  DetailView.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.locale) var locale
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy HH:mm:ss"
        formatter.locale = locale
        return formatter
    }
    
    var body: some View {
        Text(dateFormatter.string(from: viewModel.date))
            .onDisappear { trigger(.disappeared) }
    }
}

struct DetailView_Previews: PreviewProvider {
    static let viewModel = DetailViewModelFake().toAnyViewModel()
    static var previews: some View {
        DetailView(viewModel: viewModel)
    }
}
