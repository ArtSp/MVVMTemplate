//
//  CategoriesListView.swift
//  MVVMTemplate

import SwiftUI

struct CategoriesListView: View {
    @EnvironmentObject
    var viewModel: AnyViewModel<CategoriesListState, CategoriesListInput>
   
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    VStack(spacing: 6) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("CategoriesListView_loading")
                            .foregroundColor(.gray)
                    }
                } else {
                    List(viewModel.categories) { viewModel in
                        NavigationLink(destination: CategoryDetailView().environmentObject(viewModel)) {
                            CategoryCell(category: viewModel.category)
                        }
                    }
                }
                
            }
            .navigationTitle("CategoriesListView_categories \(viewModel.categories.count)")
            
        }.onAppear {
            viewModel.trigger(.fetchCategories)
        }
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static let model = CategoriesListViewModel(service: MarketServiceFake())
    static var previews: some View {
        Group {
            CategoriesListView()
                .environmentObject(AnyViewModel(model))
                .environment(\.locale, .en_US)
            CategoriesListView()
                .environmentObject(AnyViewModel(model))
                .environment(\.locale, .ru_RU)
        }
    }
}
