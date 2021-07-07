//
//  UserDetailsView.swift
//  MVVMTemplate

import SwiftUI

struct UserDetailView: View {
    @EnvironmentObject
    private var viewModel: AnyViewModel<UserDetailState, UserDetailInput>
    
    var body: some View {
        VStack {
            Text("User \(viewModel.state.user.name)")
            Text("Age: \(viewModel.state.user.age)")
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    
    private static let fakeUser = User(name: "John", age: 21)
    private static let fakeService = UserServiceFake()
    private static let fakeModel = UserDetailViewModel(user: fakeUser,
                                                       userService: fakeService)
    
    static var previews: some View {
        UserDetailView()
            .environmentObject(fakeModel)
            .environment(\.locale, .en_US)
    }
}
