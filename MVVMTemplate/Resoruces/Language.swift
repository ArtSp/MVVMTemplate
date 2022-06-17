//
//  Language.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Foundation

enum Language: Hashable, Codable {
    case english(English)
    case russian
    
    enum English: Hashable, Codable {
        case us
        case uk
        case australian
        case canadian
        case indian
    }
}

// MARK: - Init
extension Language {
    
    init?(
        languageCode: String?
    ) {
        guard let languageCode = languageCode else { return nil }
        switch languageCode {
        case "en", "en-US":     self = .english(.us)
        case "en-GB":           self = .english(.uk)
        case "en-AU":           self = .english(.australian)
        case "en-CA":           self = .english(.canadian)
        case "en-IN":           self = .english(.indian)
        case "ru-US":              self = .russian
        default:                return nil
        }
    }
}

extension Language: Identifiable {
    
    static let appSupported: [Language] = [.english(.us), .russian]
    
    var locale: Locale { .init(identifier: code) }
    var id: String { code }
    
    var code: String {
        switch self {
        case let .english(english):
            switch english {
            case .us:                return "en"
            case .uk:                return "en-GB"
            case .australian:        return "en-AU"
            case .canadian:          return "en-CA"
            case .indian:            return "en-IN"
            }
        case .russian:               return "ru-US"
        }
    }
    
    var name: String {
        switch self {
        case let .english(english):
            switch english {
            case .us:                return "English"
            case .uk:                return "English (UK)"
            case .australian:        return "English (Australia)"
            case .canadian:          return "English (Canada)"
            case .indian:            return "English (India)"
            }
        case .russian:               return "Русский"
        }
    }
}
