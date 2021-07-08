//
//  Headers.swift
//  MVVMTemplate

import Foundation

extension API.Headers {
    static func all() -> [String: String] {
        [
            "X-Device-Type": "iOS",
            "X-App-Version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
            "Accept-Language": Locale.en_US.identifier,
            "X-Accept-Version": "2"
        ]
    }
}
