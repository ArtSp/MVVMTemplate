//
//  UserCell.swift
//  MVVMTemplate

import SwiftUI

struct UserCell: View {
    let user: User
    
    var body: some View {
        HStack {
            Image(systemName: "person")
            Text(user.name)
            Spacer()
        }.padding()
    }
}

struct UserCell_Previews: PreviewProvider {
    
    private static let fakeUser = User(name: "John", age: 21)
    
    static var previews: some View {
        Group {
            UserCell(user: fakeUser)
                .environment(\.locale, .en_US)
            
            UserCell(user: fakeUser)
                .environment(\.locale, .ru_RU)
            
        }.previewLayout(.fixed(width: 300, height: 80))
    }
}
