//
//  View+Ex.swift
//  MVVMTemplate

import SwiftUI

public extension View {
    @ViewBuilder
    func textStyle(
        _ style: TextStyle
    ) -> some View {
        self.font(style.font)
    }
    
    @ViewBuilder
    func textStyle(
        _ style: TextStyle,
        color: Color
    ) -> some View {
        self.font(style.font)
            .foregroundColor(color)
    }
    
    @ViewBuilder
    func isHidden(
        _ hidden: Bool,
        remove: Bool = true
    ) -> some View {
        if !hidden {
            self
        } else if !remove {
            self.hidden()
        }
    }
    
    func Print(
        _ vars: Any...
    ) -> some View {
        vars.forEach { print($0) }
        return EmptyView()
    }
}

public struct TextStyle {
    var font: Font
    init(
        _ font: Font
    ) {
        self.font = font
    }
}
