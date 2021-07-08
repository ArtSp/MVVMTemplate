//
//  CategoryDetailView.swift
//  MVVMTemplate

import SwiftUI

struct CategoryDetailView: View {
    @EnvironmentObject
    private var viewModel: AnyViewModel<CategoryDetailState, Never>
    
    var body: some View {
        NavigationView {
            VStack {
                Text("CategoryName: \(viewModel.category.name)")
                Text("Subitems: \(viewModel.category.items)")
            }
            .navigationBarTitle(viewModel.category.name)
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    
    private static let fakeCategory = Category(name: "Category name", items: 21)
    private static let fakeService = MarketServiceFake()
    private static let fakeModel = CategoryDetailViewModel(category: fakeCategory,
                                                           service: fakeService)
    static var previews: some View {
        CategoryDetailView()
            .environmentObject(AnyViewModel(fakeModel))
            .environment(\.locale, .en_US)
    }
}
