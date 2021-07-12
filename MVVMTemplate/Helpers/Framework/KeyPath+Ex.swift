//
//  KeyPath+Ex.swift
//  MVVMTemplate

import Foundation



/// Keypath setter for closures
///
/// Example in `test()`:
///
///     class Foo {
///         var title: String?
///         var description: String?
///
///         static let shared = Foo()
///         private init() {}
///
///         private func request(text: String, completion: @escaping (String) -> Void) {
///             DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
///                 completion(text)
///             }
///         }
///         func test() {
///             request(text: "Title", completion: setter(keyPath: \.title , on: self))
///             request(text: "Description", completion: setter(keyPath: \.description , on: self))
///         }
///   }
func setter<Object: AnyObject, Value>(
    keyPath: ReferenceWritableKeyPath<Object, Value>,
    on object: Object
) -> (Value) -> Void {
    return { [weak object] value in
        object?[keyPath: keyPath] = value
    }
}

extension Sequence {
    func map<T>(
        _ keyPath: KeyPath<Element, T>
    ) -> [T] {
        map { $0[keyPath: keyPath] }
    }
    
    func sorted<T: Comparable>(
        by keyPath: KeyPath<Element, T>
    ) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}
