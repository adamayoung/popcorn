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
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            // Replaces the navigation title with an invisible view to visually
            // suppress it while keeping .inline mode so the back button stays
            // at the correct height.
            // Note: conflicts with any other .principal ToolbarItem in the same
            // navigation context.
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
