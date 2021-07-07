//
//  UserDetailsViewModel.swift
//  MVVMTemplate

import Foundation

//MARK: - State

struct UserDetailState {
    var user: User
}

//MARK: - Input

enum UserDetailInput {
}

//MARK: - ViewModel

class UserDetailViewModel: ViewModel {

    @Published
    var state: UserDetailState
    private let userService: UserService

    init(user: User, userService: UserService) {
        self.userService = userService
        self.state = UserDetailState(
            user: user
        )
    }

    func trigger(_ input: UsersListInput) {
        switch input {
        default: break
        }
    }
}
