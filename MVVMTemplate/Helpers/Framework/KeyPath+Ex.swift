//
//  KeyPath+Ex.swift
//  MVVMTemplate

import Foundation

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
