//
//  View+Ex.swift
//  MVVMTemplate

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = true) -> some View {
        if !hidden { self }
        else if !remove { self.hidden() }
    }
    
    func Print(_ vars: Any...) -> some View {
        vars.forEach { print($0) }
        return EmptyView()
    }
}
