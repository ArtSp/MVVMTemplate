//
//  Heplers.swift
//  MVVMTemplate

import SwiftUI

extension Locale {
    static let ar: Locale = .init(identifier: "ar")
    static let en_US: Locale = .init(identifier: "en_US")
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = true) -> some View {
        if !hidden { self }
        else if !remove { self.hidden() }
    }
    
    func Print(_ vars: Any...) -> some View {
        vars.forEach { print($0) }
        return EmptyView()
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        map { $0[keyPath: keyPath] }
    }
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

func setter<Object: AnyObject, Value>(keyPath: ReferenceWritableKeyPath<Object, Value>, on object: Object) -> (Value) -> Void {
    { [weak object] value in
        object?[keyPath: keyPath] = value
    }
}


