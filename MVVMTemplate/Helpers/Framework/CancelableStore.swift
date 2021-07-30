//
//  HasDisposeBag.swift
//  MVVMTemplate

import Foundation
import Combine

private var rawPointer = true

private class CancelableBag: NSObject {
    var cancelables = Set<AnyCancellable>()
}

public protocol CancelableStore: AnyObject {
    var cancelables: Set<AnyCancellable> { get set }
}

public extension CancelableStore {
    
    private func synchronizedBag<T>(
        _ action: () -> T
    ) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
    
    private var cancelableBag: CancelableBag {
        get {
            synchronizedBag {
                if let cancelableBag = objc_getAssociatedObject(self, &rawPointer) as? CancelableBag {
                    return cancelableBag
                }
                let cancelableBag = CancelableBag()
                objc_setAssociatedObject(self, &rawPointer, cancelableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancelableBag
            }
        }
        
        set {
            synchronizedBag {
                objc_setAssociatedObject(self, &rawPointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var cancelables: Set<AnyCancellable> {
        get {
            cancelableBag.cancelables
        }
        
        set {
            cancelableBag.cancelables = newValue
        }
    }
}
