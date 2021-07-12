//
//  Category.swift
//  MVVMTemplate

import Foundation

struct Category: Identifiable {
    var id = UUID()
    let name: String
    let items: Int
    let imageUrl: URL?
    
    init(
        id: UUID = UUID(),
        name: String,
        items: Int,
        imageUrl: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.items = items
        self.imageUrl = imageUrl
    }
}

extension Category {
    struct Configurator<Model> {
        let nameKeyPath: KeyPath<Model, String>
        let itemsKeyPath: KeyPath<Model, [Model]?>
        let imageUrlKeyPath: KeyPath<Model, String?>
        
        func create(from model: Model) -> Category {
            var url: URL?
            if let urlString = model[keyPath: imageUrlKeyPath] {
                url = URL(string: urlString)
            }
            
            return Category(
                name: model[keyPath: nameKeyPath],
                items: model[keyPath: itemsKeyPath]?.count ?? 0,
                imageUrl: url
            )
        }
    }
}

extension CategoriesResponse.CategoryItem {
    func toDomain() -> Category {
        Category.Configurator<Self>(
            nameKeyPath: \.title,
            itemsKeyPath: \.subcategories,
            imageUrlKeyPath: \.imageUrl
        ).create(from: self)
    }
}

// MARK: - Fakes

extension Category {
    static let fakes: [Category] = [
        Category(name: "Outdoor & Garden", items: 12),
        Category(name: "Electronics", items: 18)
    ]
}
