//
//  UsersListViewModel.swift
//  MVVMTemplate

import Foundation
import Combine

//MARK: - State

struct UsersListState {
    var users = [AnyViewModel<UserDetailState, UserDetailInput>]()
    var isLoading = false
}

//MARK: - Input

enum UsersListInput {
    case fetchUsers
}

//MARK: - ViewModel

class UsersListViewModel: ViewModel {

    @Published
    var state = UsersListState()
    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
    }
    
    private func fetchUsers() {
        guard !state.isLoading else { return }
        state.isLoading = true
        
        userService.getUsers()
            .map { values in values.map { AnyViewModel(UserDetailViewModel(user: $0, userService: self.userService)) } }
            .assertNoFailure()
            .sink(receiveCompletion: { _ in
                self.state.isLoading = false
            }, receiveValue: { users in
                self.state.users = users
            })
            .store(in: &disposeBag)
    }

    func trigger(_ input: UsersListInput) {
        switch input {
        case .fetchUsers:
            fetchUsers()
        }
    }
}
