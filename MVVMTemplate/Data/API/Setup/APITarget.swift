//
//  APITarget.swift
//  Created by Artjoms Spole on 03/06/2022.
//

extension API {
    enum Target: String, Codable, CaseIterable {
        case production
        
        @Atomic static var current: Target = .init()
        
        private var host: String {
            switch self {
            case .production: return "https://dummyjson.com"
            }
        }
        
        var title: String {
            self.rawValue
        }
        
        var baseURL: URL {
            URL(string: host)!
        }
        
        // Set default instance:
        init() {
            self = .production
        }
    }
}
