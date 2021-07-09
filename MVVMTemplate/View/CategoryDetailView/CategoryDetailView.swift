//
//  CategoryDetailView.swift
//  MVVMTemplate

import SwiftUI

//MARK: - State

struct CategoryDetailState: Identifiable {
    var id: Category.ID { category.id }
    var category: Category
}

//MARK: - View

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

//MARK: - Preview

struct UserDetailView_Previews: PreviewProvider {
    
    private static let category = Category.fakes[0]
    private static let service = MarketServiceFake()
    private static let model = CategoryDetailViewModel(category: category, service: service)
    
    static var previews: some View {
        CategoryDetailView()
            .environmentObject(AnyViewModel(model))
            .environment(\.locale, .en_US)
    }
}
