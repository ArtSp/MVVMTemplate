//
//  UserService.swift
//  MVVMTemplate

import Foundation
import Combine

// MARK: - UserService
protocol UserService {
    typealias UserResponse = ([User]) -> Void
    func getUsers(completed: @escaping UserResponse)
    func createUser(_ user: User)
    func updateUser(_ user: User)
    func deleteUser(_ user: User)
}

// MARK: - UserServiceImpl

final class UserServiceImpl: UserService {
    func getUsers(completed: @escaping UserResponse) {}
    func createUser(_ user: User) {}
    func updateUser(_ user: User) {}
    func deleteUser(_ user: User) {}
}

// MARK: - UserServiceFake

final class UserServiceFake: UserService {
    private let requestTime = 2.0
    private var fakeUsers = [
        User(name: "User 1", age: 12),
        User(name: "User 2", age: 18),
    ]
    
    func getUsers(completed: @escaping UserResponse) {
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTime) {
            completed(self.fakeUsers)
        }
    }
    
    func createUser(_ user: User) {}
    func updateUser(_ user: User) {}
    func deleteUser(_ user: User) {}
}

