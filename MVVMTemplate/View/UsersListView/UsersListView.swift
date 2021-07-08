//
//  UsersListView.swift
//  MVVMTemplate

import SwiftUI

struct UsersListView: View {
    @EnvironmentObject
    var viewModel: AnyViewModel<UsersListState, UsersListInput>
   
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    VStack(spacing: 6) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("UsersListView_loading")
                            .foregroundColor(.gray)
                    }
                } else {
                    List(viewModel.users) { viewModel in
                        NavigationLink(destination: UserDetailView().environmentObject(viewModel)) {
                            UserCell(user: viewModel.user)
                        }
                    }
                }
                
            }.navigationTitle("UsersListView_users \(viewModel.users.count)")
            
        }.onAppear { viewModel.trigger(.fetchUsers) }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static let model = UsersListViewModel(userService: UserServiceFake())
    static var previews: some View {
        Group {
            UsersListView()
                .environmentObject(AnyViewModel(model))
                .environment(\.locale, .en_US)
            UsersListView()
                .environmentObject(AnyViewModel(model))
                .environment(\.locale, .ru_RU)
        }
    }
}
