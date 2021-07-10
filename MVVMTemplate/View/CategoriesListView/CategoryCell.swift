//
//  UserCell.swift
//  MVVMTemplate

import SwiftUI

// MARK: - View

struct CategoryCell: View {
    let category: Category
   
    @ViewBuilder
    private var placeholder: some View {
        Color(.lightGray.withAlphaComponent(0.3))
            .cornerRadius(5)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Group {
                if let url = category.imageUrl {
                    AsyncImage(
                        url: url,
                        placeholder: {
                            placeholder
                        },
                        image: {
                            Image(uiImage: $0)
                                .resizable()
                        }
                    )
                } else {
                    placeholder
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(category.name)
                .textStyle(.h1)
            Spacer()
            if category.items > 0 {
                Text("\(category.items)")
                    .textStyle(.body1)
                    .foregroundColor(.gray.opacity(0.8))                
            }
            
        }
        .padding(.vertical)
    }
}

// MARK: - Preview

struct UserCell_Previews: PreviewProvider {
    
    private static let category = Category.fakes[0]
    
    static var previews: some View {
        Group {
            CategoryCell(category: category)
                .environment(\.locale, .en_US)
            
            CategoryCell(category: category)
                .environment(\.locale, .ru_RU)
            
        }.previewLayout(.fixed(width: 300, height: 80))
    }
}
