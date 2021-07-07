//
//  SubscriberStore.swift
//  MVVMTemplate

import Foundation
import Combine

fileprivate var rawPointer = true

public protocol SubscriberStore: AnyObject {
    typealias Subscribers = Set<AnyCancellable>
    var subscribers: Subscribers { get set }
}

public extension SubscriberStore {
    
    private func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
    
    var subscribers: Subscribers {
        get {
            synchronizedBag {
                if let subscribers = objc_getAssociatedObject(self, &rawPointer) as? Subscribers {
                    return subscribers
                }
                let subscribers = Subscribers()
                objc_setAssociatedObject(self, &rawPointer, subscribers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return subscribers
            }
        }
        
        set {
            synchronizedBag {
                objc_setAssociatedObject(self, &rawPointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
