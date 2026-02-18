//
//  PopcornApp.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import SwiftUI

@main
struct PopcornApp: App {

    @StateObject private var store: StoreOf<AppRootFeature>

    init() {
        _store = StateObject(wrappedValue: Store(
            initialState: AppRootFeature.State()
        ) {
            AppRootFeature()
        })
    }

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
