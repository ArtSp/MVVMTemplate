//
//  Error+Ex.swift
//  Created by Artjoms Spole on 06/06/2022.
//

import Combine

private let errorShowSubject = PassthroughSubject<Error, Never>()

extension Error {
    
    /// Publisher for showInContent requests
    static var showInContentPublisher: AnyPublisher<Error, Never> {
        errorShowSubject.eraseToAnyPublisher()
    }
    
    /// Shows error in ContentView
    func showInContent() {
        errorShowSubject.send(self)
    }
}
