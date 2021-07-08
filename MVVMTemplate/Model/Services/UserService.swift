//
//  UserService.swift
//  MVVMTemplate

import Foundation
import Combine

// MARK: - UserService
protocol UserService {
    func getUsers() -> AnyPublisher<[User], Never>
    func createUser(_ user: User)
    func updateUser(_ user: User)
    func deleteUser(_ user: User)
}

// MARK: - UserServiceImpl

final class UserServiceImpl: UserService {
    func getUsers() -> AnyPublisher<[User], Never> {
        API.Products.GetCategories().request()
            .receive(on: DispatchQueue.main)
            .map { response in
                response.categoryItems.map {
                    User(name: $0.title,
                         age: 0)
                }
            }
            .assertNoFailure()
            .eraseToAnyPublisher()
    }
    func createUser(_ user: User) {}
    func updateUser(_ user: User) {}
    func deleteUser(_ user: User) {}
}

// MARK: - UserServiceFake

final class UserServiceFake: UserService {
    private var users = [
        User(name: "User 1", age: 12),
        User(name: "User 2", age: 18),
    ]
    
    func getUsers() -> AnyPublisher<[User], Never> {
        Just(users).eraseToAnyPublisher()
    }
    
    func createUser(_ user: User) {}
    func updateUser(_ user: User) {}
    func deleteUser(_ user: User) {}
}

