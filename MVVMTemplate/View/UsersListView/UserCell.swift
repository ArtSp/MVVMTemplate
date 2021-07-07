//
//  UserCell.swift
//  MVVMTemplate

import SwiftUI

struct UserCell: View {
    let user: User
    
    var body: some View {
        Text(user.name)
    }
}

struct UserCell_Previews: PreviewProvider {
    
    private static let fakeUser = User(name: "John", age: 21)
    
    static var previews: some View {
        UserCell(user: fakeUser)
            .environment(\.locale, .en_US)
    }
}
