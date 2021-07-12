//
//  NavigationButton.swift
//  MVVMTemplate

import SwiftUI

struct NavigationButton<Destination: View, Label: View>: View {
    typealias Action = () -> Void
    
    @State
    private var isActive: Bool = false
    private var action: Action?
    private var destination: () -> Destination
    private var label: () -> Label
    
    init(
        action: Action? = nil,
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.action = action
        self.destination = destination
        self.label = label
    }

    var body: some View {
        Button(
            action: {
                action?()
                isActive.toggle()
            },
            label: {
                label()
                    .background(
                        ScrollView { // Fixes a bug where the navigation bar may become hidden on the pushed view
                            NavigationLink(destination: destination(), isActive: $isActive) { EmptyView() }
                        }
                    )
            }
        )
    }
}
