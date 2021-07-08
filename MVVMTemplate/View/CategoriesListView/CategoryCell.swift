//
//  UserCell.swift
//  MVVMTemplate

import SwiftUI

struct CategoryCell: View {
    let category: Category
    
    var body: some View {
        HStack {
            Image(systemName: "person")
            Text(category.name)
            Spacer()
        }.padding()
    }
}

struct UserCell_Previews: PreviewProvider {
    
    private static let fakeCategory = Category(name: "John", items: 21)
    
    static var previews: some View {
        Group {
            CategoryCell(category: fakeCategory)
                .environment(\.locale, .en_US)
            
            CategoryCell(category: fakeCategory)
                .environment(\.locale, .ru_RU)
            
        }.previewLayout(.fixed(width: 300, height: 80))
    }
}
