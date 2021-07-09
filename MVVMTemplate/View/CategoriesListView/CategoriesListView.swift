//
//  CategoriesListView.swift
//  MVVMTemplate

import SwiftUI

//MARK: - State

struct CategoriesListState {
    var categories = [AnyViewModel<CategoryDetailState, Never>]()
    var isLoading = false
    fileprivate var isShowingError = false
    fileprivate var error: Error?
    
    mutating func showError(_ error: Error) {
        isShowingError = true
        self.error = error
    }
}

//MARK: - Input

enum CategoriesListInput {
    case fetchCategories
}

// MARK: - View

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
            .alert(isPresented: $viewModel.state.isShowingError) {
                Alert(title: Text("Error"),
                      message: Text( viewModel.error?.localizedDescription ?? ""),
                      dismissButton: .default(Text("Ok")))
            }
            
        }.onAppear {
            viewModel.trigger(.fetchCategories)
        }
    }
}

// MARK: - Preview

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
