//
//  HasDisposeBag.swift
//  MVVMTemplate

import Foundation
import Combine

fileprivate var rawPointer = true

public typealias DisposeBag = Set<AnyCancellable>

public extension DisposeBag {
    static var shared = DisposeBag()
}

public protocol HasDisposeBag: AnyObject {
    var disposeBag: DisposeBag { get set }
}

public extension HasDisposeBag {
    
    private func synchronizedBag<T>(
        _ action: () -> T
    ) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
    
    var disposeBag: DisposeBag {
        get {
            synchronizedBag {
                if let subscribers = objc_getAssociatedObject(self, &rawPointer) as? DisposeBag {
                    return subscribers
                }
                let subscribers = DisposeBag()
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
