//
//  API.swift
//  Created by Artjoms Spole on 03/06/2022.
//

import Combine

enum API {
    // Specity BE models here:
    enum Model {}
    
    // Get current token here:
    static var authToken: String? { nil }
    
    // Get/Refresh token here:
    static func getToken() -> AnyPublisher<String?, Never> {
        Just(nil).eraseToAnyPublisher()
    }
    
    // Handle unauthorized request error here:
    static let unauthorizedClosure: ErrorHandler.UnauthorizedClosure = { error in
        print("Unauthorized!", error.localizedDescription)
    }
}

extension API {
    static var baseURL: URL { Target.current.baseURL }
    
    static func headers(
        authToken: String?
    ) -> [String: String] {
        [
            "Authorization": authToken
        ].compactMapValues { $0 }
    }
}
