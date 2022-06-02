//
//  View+Ex.swift
//  Created by Artjoms Spole on 02/06/2022.
//

extension View {
    func localePreview() -> some View {
        self.localePreview(locales: Locale.appSupported)
    }
}
