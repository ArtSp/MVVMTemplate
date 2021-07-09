//
//  Target.swift
//  MVVMTemplate

import Foundation

enum Target: String, Codable, CaseIterable {
    case production
    case developement
    
    @UserDefault(key: "environment", defaultValue: API.target)
    static var current: Target
    
    var title: String {
        self.rawValue
    }
    
    var baseURL: URL {
        switch self {
        case .production:   return URL(string: "http://sacoprodalb-658046925.me-south-1.elb.amazonaws.com/api")!
        case .developement: return URL(string: "http://15.185.180.169/api/")!
        }
    }
    
    init() {
        #if LIVE
        self = .production
        #else
        self = .developement
        #endif
    }
}
