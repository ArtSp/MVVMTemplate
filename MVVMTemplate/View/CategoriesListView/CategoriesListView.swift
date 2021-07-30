//
//  CategoriesListView.swift
//  MVVMTemplate

import SwiftUI

// MARK: - State

struct CategoriesListState {
    var categories = [AnyViewModel<CategoryDetailState, Never>]()
    var isLoading = false
    var profileImage: UIImage?
    var isShowingImagePicker = false
    
    fileprivate var isShowingError = false
    fileprivate var error: Error?
    
    mutating func showError(
        _ error: Error
    ) {
        isShowingError = true
        self.error = error
    }
}

// MARK: - Input

enum CategoriesListInput {
    case fetchCategories
    case selectedProfileImage(UIImage)
    case showImagePicker
}

// MARK: - View

struct CategoriesListView: View {
    @EnvironmentObject
    var viewModel: AnyViewModel<CategoriesListState, CategoriesListInput>
    @State private var inputImage: UIImage?
    
    @ViewBuilder
    private var profileImage: some View {
        if let uiImage = viewModel.profileImage {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .padding(6)
        }
    }
    
    private var trailingNavigationView: some View {
        profileImage
            .frame(width: 30, height: 30, alignment: .center)
            .background(Color(.lightText))
            .clipShape(Circle())
            .shadow(radius: 3)
            .onTapGesture {
                pickProfileImage()
            }
    }
   
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
                        if viewModel.category.items == .zero {
                            CategoryCell(category: viewModel.category)
                        } else {
                            NavigationLink(destination: CategoryDetailView().environmentObject(viewModel)) {
                                CategoryCell(category: viewModel.category)
                            }
                        }
                    }
                }
            }
            .navigationTitle("CategoriesListView_categories \(viewModel.categories.count)")
            .navigationBarItems(trailing: trailingNavigationView)
            .alert(isPresented: $viewModel.state.isShowingError) {
                Alert(title: Text("Error"),
                      message: Text( viewModel.error?.localizedDescription ?? ""),
                      dismissButton: .default(Text("Ok")))
            }
        }
        .onAppear {
            loadCategories()
        }
        .sheet(isPresented: $viewModel.state.isShowingImagePicker,
               onDismiss: saveProfileImage) {
            ImagePicker(image: $inputImage)
        }
    }
    
    private func pickProfileImage() {
        viewModel.trigger(.showImagePicker)
    }
    
    private func loadCategories() {
        viewModel.trigger(.fetchCategories)
    }
    
    private func saveProfileImage() {
        guard let inputImage = inputImage else { return }
        viewModel.trigger(.selectedProfileImage(inputImage))
    }
}

// MARK: - Preview

struct CategoriesListView_Previews: PreviewProvider {
    static let model = AnyViewModel(CategoriesListViewModel.fake())
    static var previews: some View {
        Group {
            CategoriesListView()
                .environmentObject(model)
                .environment(\.locale, .en_US)
            CategoriesListView()
                .environmentObject(model)
                .environment(\.locale, .ru_RU)
        }
    }
}
