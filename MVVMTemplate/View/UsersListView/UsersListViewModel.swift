//
//  UsersListViewModel.swift
//  MVVMTemplate

import Foundation

//MARK: - State

struct UsersListState {
    var users: [AnyViewModel<UserDetailState, UserDetailInput>]
    var isLoading: Bool
    var navigationBarTitle: String { "Users \(users.count)" }
}

//MARK: - Input

enum UsersListInput {
    case fetchUsers
}

//MARK: - ViewModel

class UsersListViewModel: ViewModel {

    @Published
    var state: UsersListState
    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
        self.state = UsersListState(
            users: [],
            isLoading: false
        )
    }
    
    private func fetchUsers() {
        guard !state.isLoading else { return }
        state.isLoading = true
//        userService.getUsers { //[weak self] users in
//                        self?.state.users = users
//                            .map { UserDetailViewModel(user: $0, userService: userService) }
//                            .map { AnyViewModel($0) }
//            self?.state.isLoading = false
//        }
    }

    func trigger(_ input: UsersListInput) {
        switch input {
        case .fetchUsers:
            fetchUsers()
        }
    }
}
