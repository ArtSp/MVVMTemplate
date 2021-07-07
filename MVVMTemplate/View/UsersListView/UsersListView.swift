//
//  UsersListView.swift
//  MVVMTemplate

import SwiftUI

extension UserDetailState: Identifiable {
    var id: User.ID {
        user.id
    }
}

struct UsersListView: View {
    @EnvironmentObject
    var viewModel: AnyViewModel<UsersListState, UsersListInput>
   
    var body: some View {
        NavigationView {
            List(viewModel.state.users) { viewModel in
                NavigationLink(destination: UserDetailView().environmentObject(viewModel)) {
                    UserCell(user: viewModel.user)
                }
            }
            .navigationTitle(viewModel.state.navigationBarTitle)
        }.onAppear { viewModel.trigger(.fetchUsers) }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
            .environment(\.locale, .en_US)
            .environmentObject(UsersListViewModel(userService: UserServiceFake()))
    }
}
