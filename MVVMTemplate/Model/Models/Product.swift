//
//  Product.swift
//  Created by Artjoms Spole on 06/06/2022.
//

struct Product: Identifiable {
    let id: ID
    let title: String
    let price: Price
    let inStock: Bool
    let thumbnailImage: URL
    let images: [URL]
}

extension API.Model.Product: ToDomainMapping {
    func toDomain() throws -> Product {
        guard let thumbnailImage = URL(string: thumbnail) else { throw "Thumbnail image bad url" }
        let imageUrls = try images.map { image -> URL in
            guard let imageUrl = URL(string: image) else { throw "Image bad url" }
            return imageUrl
        }
        return .init(id: id,
                     title: title,
                     price: price,
                     inStock: stock > 0,
                     thumbnailImage: thumbnailImage,
                     images: imageUrls)
    }
}

extension Product: PlaceholderProvider {
    static var placeholder: Self = .init(
        id: -1,
        title: "Product Title",
        price: 999,
        inStock: false,
        thumbnailImage: URL(string: .loopBack)!,
        images: .init()
    )
}
