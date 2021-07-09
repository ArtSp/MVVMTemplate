//
//  TextStyle.swift
//  MVVMTemplate

import SwiftUI

extension View {
    @ViewBuilder func textStyle(_ style: TextStyle) -> some View {
        self.font(style.font)
    }
}

enum TextStyle {
    // Add all supported textStyles
    case body1, h1
    
    var font: Font {
        switch self {
        case .body1: return .body
        case .h1: return .headline
        }
    }
}
