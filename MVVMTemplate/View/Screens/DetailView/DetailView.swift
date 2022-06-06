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
    @State private var scrollViewMinSize: CGSize = .zero
    @State private var scrollViewOffset: CGPoint = .zero
    
    var isModal: Bool
    var topImageWidth: CGFloat { scrollViewMinSize.width }
    var topImageHeight: CGFloat { topImageWidth * 0.8 }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy HH:mm:ss"
        formatter.locale = locale
        return formatter
    }
    
    func transformRatio(
        for offset: CGPoint
    ) -> CGFloat {
        let y = offset.y
        let ratio = (topImageHeight + y) / topImageHeight
        return ratio
    }
    
    func overlay(
        for imageUrl: URL
    ) -> Color {
        let color = Color.shimmerBgd.opacity(0.6)
        guard let selectedImage = viewModel.selectedImage else { return color }
        return selectedImage == imageUrl ? .clear : color
    }
    
    func image(
        for offset: CGPoint
    ) -> some View {
        Unwrap(viewModel.selectedImage) { selectedImageUrl in
            MPAsyncImage(
                url: selectedImageUrl,
                resultModifier: { $0.resizable() },
                placeholder: { Placeholder().shimmed() }
            )
                .scaledToFill()
                .frame(width: topImageWidth, height: topImageHeight)
                .clipped()
                .if(offset.y > 0) { view in
                    view.transformEffect(
                        .init(
                            scaleX: transformRatio(for: offset), y: transformRatio(for: offset)
                        ).concatenating(
                            .init(
                                translationX: (topImageWidth - transformRatio(for: offset) * topImageWidth) / 2, y: -offset.y
                            )
                        )
                    )
                }
                
        } fallbackContent: {
            Rectangle()
                .frame(width: scrollViewMinSize.width, height: scrollViewMinSize.width * 0.8)
                .asPlaceholder()
                .shimmed()
                .isHidden(viewModel.isLoading.isEmpty)
        }
    }
    
    var images: some View {
        Unwrap(viewModel.product?.images) { images in
            LazyHStack(spacing: 15) {
                ForEach(images, id: \.self) { imageUrl in
                    ZStack {
                        MPAsyncImage(
                            url: imageUrl,
                            resultModifier: { $0.resizable() },
                            placeholder: { Placeholder().shimmed() }
                        )
                        .scaledToFill()
                        .frame(width: 82, height: 82)
                        .clipped()
                    }
                    .overlay(overlay(for: imageUrl))
                    .onTapGesture {
                        withAnimation {
                            viewModel.trigger(.selectedImage(imageUrl))
                        }
                    }
                }
            }
            .frame(height: 82)
            .padding(.horizontal)
            .scrollView(.horizontal, showsIndicators: false)
            
        } fallbackContent: {
            HStack(spacing: 6) {
                ForEach(0..<6, id: \.self) { _ in
                    Rectangle()
                        .frame(width: 82, height: 82)
                        .asPlaceholder()
                }
            }
            .scrollView(.horizontal, showsIndicators: false)
            .padding(.horizontal)
            .disabled(true)
            .shimmed()
            .isHidden(viewModel.isLoading.isEmpty)
        }
    }
    
    func productDetails(
        for product: Product,
        isPlaceholder: Bool
    ) -> some View {
        VStack(spacing: 6) {
            Text(product.title)
                .textStyle(.h1)
                .if(isPlaceholder) { $0.asPlaceholder() }
            Text(product.price.formattedPrice(locale: locale))
                .textStyle(.body1)
                .if(isPlaceholder) { $0.asPlaceholder() }
        }
    }
    var body: some View {
        
        ZStack {
            Color.clear
                .readSize { scrollViewMinSize = $0 }
            
            VStack(alignment: .center, spacing: 10) {
                image(for: scrollViewOffset)
                images
                
                Unwrap(viewModel.product) { product in
                    productDetails(for: product, isPlaceholder: false)
                } fallbackContent: {
                    productDetails(for: Product.placeholder, isPlaceholder: true)
                        .shimmed()
                        .isHidden(viewModel.isLoading.isEmpty)
                }
                
                Spacer()
                
                Text("detail.body.date")
                    .textStyle(.h1)
                Text(dateFormatter.string(from: viewModel.date))
                    .textStyle(.body1)
                Button("detail.navigation.dismiss") {
                    dismiss()
                }
                .isHidden(!isModal)
            }
            .frame(minHeight: scrollViewMinSize.height)
            .readFrame(space: .global) { rect in
                scrollViewOffset = rect.origin
            }
            .scrollView(.vertical, showsIndicators: false)
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
