//
//  View+PlatformModal.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

extension View {

    /// Presents `content` for the bound `item` as a full-screen cover on iOS /
    /// visionOS and as a sheet on macOS.
    ///
    /// Collapses the `#if !os(macOS)` `fullScreenCover(item:)`-vs-`sheet(item:)`
    /// split that every tab root repeated for its modally-presented screens
    /// (intelligence chats, the Plot Remix game).
    @ViewBuilder
    func platformModal<Item: Identifiable>(
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> some View
    ) -> some View {
        #if os(macOS)
            sheet(item: item, content: content)
        #else
            fullScreenCover(item: item, content: content)
        #endif
    }

}
