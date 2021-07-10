//
//  ViewFontStyle.swift
//  MVVMTemplate

import SwiftUI

extension View {
    @ViewBuilder func textStyle(_ style: TextStyle) -> some View {
        self.font(style.font)
    }
    
    @ViewBuilder func textStyle(_ style: TextStyle, color: Color) -> some View {
        self.font(style.font)
            .foregroundColor(color)
    }
}

struct TextStyle {
    var font: Font
    init(_ font: Font) {
        self.font = font
    }
}
