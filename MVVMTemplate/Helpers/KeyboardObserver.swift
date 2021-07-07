//
//  KeyboardObserver.swift
//  MVVMTemplate

import UIKit
import SwiftUI

final class KeyboardObserver: ObservableObject {
    
    static let shared = KeyboardObserver()

    @Published
    private(set) var rect: CGRect = .zero

    var height: CGFloat { rect.height }

    private init() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                         name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
    }

    @objc private func keyboardWillHide(notification: Notification) {
        rect = .zero
    }

}
