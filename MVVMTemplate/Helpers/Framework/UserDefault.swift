//
//  UserDefault.swift
//  MVVMTemplate

import Foundation
import Combine

@propertyWrapper
public struct UserDefault<Value: Codable> {
    
    private let key: String
    private let defaultValue: Value
    private var container: UserDefaults
    private let publisher = PassthroughSubject<Value, Never>()
    
    init(
        key: String,
        defaultValue: Value,
        container: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
    
    /// Value publisher
    ///
    ///     let subscription = UserDefaults.$username.sink { username in
    ///         print("New username: \(username)")
    ///     }
    ///     UserDefaults.username = "Test"
    ///     // Prints "New username: Test"
    ///
    public var projectedValue: AnyPublisher<Value, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    public var wrappedValue: Value {
        get {
            guard let data = container.data(forKey: key) else { return defaultValue }
            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                let data = try? JSONEncoder().encode(newValue)
               container.setValue(data, forKey: key)
            }
            publisher.send(newValue)
        }
    }
}

public extension UserDefault where Value: ExpressibleByNilLiteral {
    init(
        key: String
    ) {
        self.init(key: key, defaultValue: nil)
    }
}
