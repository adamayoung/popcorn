//
//  PopcornApp.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import SwiftUI

@main
struct PopcornApp: App {

    @StateObject private var store = Store(
        initialState: AppRootFeature.State(),
        reducer: {
            AppRootFeature()
        }
    )

    var body: some Scene {
        #if os(macOS)
            MacScene(store: store)
        #elseif os(visionOS)
            VisionScene(store: store)
        #else
            PhoneScene(store: store)
        #endif
    }
}
