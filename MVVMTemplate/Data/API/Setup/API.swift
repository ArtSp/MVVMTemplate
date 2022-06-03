//
//  API.swift
//  Created by Artjoms Spole on 03/06/2022.
//

enum API {
    // Specity BE models here:
    enum Model {}
    
    // Set token here:
    static var authToken: String? { nil }
    
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
