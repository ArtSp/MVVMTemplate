//
//  CategoryDetailView.swift
//  MVVMTemplate

import SwiftUI

// MARK: - State

struct CategoryDetailState: Identifiable {
    var id: Category.ID { category.id }
    var category: Category
}

// MARK: - View

struct CategoryDetailView: View {
    @EnvironmentObject
    private var viewModel: AnyViewModel<CategoryDetailState, Never>
    
    var body: some View {
        Form {
            Text("CategoryName: \(viewModel.category.name)")
            Text("Subitems: \(viewModel.category.items)")
        }
        .navigationTitle(viewModel.category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

struct UserDetailView_Previews: PreviewProvider {
    
    private static let model = AnyViewModel(CategoryDetailViewModel.fake())
    
    static var previews: some View {
        Group {
            CategoryDetailView()
                .environmentObject(model)
                .environment(\.locale, .en_US)
            CategoryDetailView()
                .environmentObject(model)
                .environment(\.locale, .ru_RU)
        }
    }
}
