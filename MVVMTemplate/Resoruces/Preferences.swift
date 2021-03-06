//
//  Preferences.swift
//  Created by Artjoms Spole on 02/06/2022.
//

import Combine
import Foundation

/// Preperty wrapper that allows to notify swiftUI about property changes
@propertyWrapper
struct Preference<Value>: DynamicProperty {
    
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences = .shared
    
    init(
        _ keyPath: ReferenceWritableKeyPath<Preferences, Value>
    ) {
        self.keyPath = keyPath
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }
            .mapToVoid()
            .eraseToAnyPublisher()
        self.preferencesObserver = .init(publisher: publisher)
    }

    var wrappedValue: Value {
        get {
            preferences[keyPath: keyPath]
        }
        nonmutating set {
            preferences[keyPath: keyPath] = newValue
            preferences.preferencesChangedSubject.send(keyPath)
        }
    }

    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

// Class for storing all app preferences
final class Preferences {
    
    static let shared = Preferences()
    private init() {}
    
    /// Sends through the changed key path whenever a change occurs.
    fileprivate var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()

    @UserDefault("onboardingCompleted")
    var onboardingCompleted = false
    
    var bundleLanguage: Language {
        get { Bundle.language ?? .english(.us) }
        set { Bundle.setLanguage(newValue) }
    }
}
