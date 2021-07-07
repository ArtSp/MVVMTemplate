//
//  UserDefault.swift
//  MVVMTemplate

import Foundation

@propertyWrapper
public struct UserDefault<T: Codable> {
    
    private let key: String
    private let defaultValue: T

    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                // Convert newValue to data
                let data = try? JSONEncoder().encode(newValue)
                // Set value to UserDefaults
                UserDefaults.standard.setValue(data, forKey: key)
            }
        }
    }
}

public extension UserDefault where T: ExpressibleByNilLiteral {
    init(key: String) {
        self.init(key: key, defaultValue: nil)
    }
}


