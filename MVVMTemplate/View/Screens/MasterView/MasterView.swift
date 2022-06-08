//
//  MasterView.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import SwiftUI

struct MasterView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.locale) var locale
    @State private var detailViewLastDispayDuration: TimeInterval?
    @State private var contentSize: CGSize = .zero
    
    enum Const {
        static let imageSize: CGSize = .init(width: 80, height: 80)
        static let cornerRadius: CGFloat = 2
    }
    
    var imageShape: some Shape {
        RoundedRectangle(cornerRadius: Const.cornerRadius)
    }
    
    var imageMask: some View {
        imageShape
            .frame(width: Const.imageSize.width,
                   height: Const.imageSize.height,
                   alignment: .center)
    }
    
    func cell(
        for product: Product
    ) -> some View {
        HStack {
            MPAsyncImage(url: product.thumbnailImage) { image in
                image
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: Const.imageSize.width,
                   height: Const.imageSize.height,
                   alignment: .center)
            .clipShape(imageShape)
            .shadow(radius: 1)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .textStyle(.h1)

                Text(product.price.formattedPrice(locale: locale))
                    .textStyle(.body1)
            }
            
            Spacer()
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: Const.cornerRadius)
                .foregroundColor(.white)
                .shadow(radius: 3)
        )
        .padding(.horizontal, 6)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.readSize { contentSize = $0 }
                
                VStack(spacing: 10) {
                    Unwrap(detailViewLastDispayDuration) { time in
                        Text("master.body.detailsDisplayDuration \(Int(time))")
                    }
                    
                    Unwrap(viewModel.products) { products in
                        LazyVStack {
                            ForEach(products) { product in
                                Button(
                                    action: { trigger(.openDetails(product.id)) },
                                    label: { cell(for: product) }
                                )
                                .foregroundColor(.black)
                            }
                        }
                    } fallbackContent: {
                        VStack {
                            ForEach(Product.placeholders(count: 3)) {
                                cell(for: $0).redacted(reason: .placeholder)
                            }
                        }
                        .isHidden(!viewModel.isLoading.contains(.products))
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: contentSize.height)
                .scrollView(.vertical, showsIndicators: false)
                .redacted(!viewModel.isLoading.isEmpty)
            }
            .textStyle(.body1)
            .multilineTextAlignment(.center)
            .navigationTitle("master.navigation.title")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.useModalPresentation ? "master.body.modal" : "master.body.navBar") {
                        trigger(.setModalDisplayMode(!viewModel.useModalPresentation))
                    }
                }
            }
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
