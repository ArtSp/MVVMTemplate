//
//  View+Ex.swift
//  Created by Artjoms Spole on 02/06/2022.
//

extension View {
    func localePreview() -> some View {
        self.localePreview(locales: Locale.appSupported)
    }
    
    func shimmed(
        intensity: Double = 0.5,
        shimmerColor: Color = .shimmer,
        shimmerBackgroundColor: Color = .shimmerBgd,
        shimmerAnimationDuration: TimeInterval = 1.5,
        shimmerDelay: TimeInterval? = nil
    ) -> some View {
        modifier(
            Shimmer(
                intensity: intensity,
                shimmerColor: shimmerColor,
                shimmerBackgroundColor: shimmerBackgroundColor,
                shimmerAnimationDuration: shimmerAnimationDuration,
                shimmerDelay: shimmerDelay
            )
        )
    }
}
