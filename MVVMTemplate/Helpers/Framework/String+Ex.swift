//
//  String+Ex.swift
//  MVVMTemplate

import Foundation

public extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "\(self)_comment")
    }
      
    func localized(
        with arguments: [CVarArg]
    ) -> String {
        String(format: localized, arguments: arguments)
    }
    
}

extension String: LocalizedError {
    public var errorDescription: String? { self }
}
