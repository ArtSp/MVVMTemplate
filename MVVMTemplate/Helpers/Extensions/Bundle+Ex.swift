//
//  Bundle+Ex.swift
//  Created by Artjoms Spole on 17/06/2022.
//

import Foundation

private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {
    
    override func localizedString(
        forKey key: String,
        value: String?,
        table tableName: String?
    ) -> String {
        guard let string = (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return string
    }
}

extension Bundle {
    
    static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()
    
    static var language: Language? {
        guard let languages = UserDefaults.standard.array(forKey: "AppleLanguages") as? [String] else { return nil }
        return .init(languageCode: languages.first)
    }
    
    static func setLanguage(
        _ language: Language
    ) {
        Bundle.once
        
        let isLanguageRTL = Locale.characterDirection(forLanguage: language.code) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight
        
        UserDefaults.standard.set(isLanguageRTL, forKey: "AppleTe  zxtDirection")
        UserDefaults.standard.set(isLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        guard let path = Bundle.main.path(forResource: language.code, ofType: "lproj") else {
            print("Failed to get a bundle path.")
            return
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
