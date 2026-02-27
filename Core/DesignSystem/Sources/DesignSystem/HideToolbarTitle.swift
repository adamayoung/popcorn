//
//  HideToolbarTitle.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct HideToolbarTitle: ViewModifier {

    func body(content: Content) -> some View {
        content
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Color.clear.frame(height: 0)
                }
            }
    }

}

public extension View {

    func hideToolbarTitle() -> some View {
        modifier(HideToolbarTitle())
    }

}
