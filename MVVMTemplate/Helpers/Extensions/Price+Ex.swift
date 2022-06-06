//
//  Price+Ex.swift
//  Created by Artjoms Spole on 06/06/2022.
//

extension Price {
    func formattedPrice(
        locale: Locale,
        fractionDigits: Int = 2,
        currencyCode: String? = Locale.en_US.currencyCode
    ) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = fractionDigits
        formatter.minimumFractionDigits = fractionDigits
        formatter.numberStyle = .currency
        if let currencyCode = currencyCode {
            formatter.currencyCode = currencyCode
        }
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
