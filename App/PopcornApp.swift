//
//  PopcornApp.swift
//  Popcorn
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import FeatureFlagsAdapters
import SwiftUI

@main
struct PopcornApp: App {

    @StateObject private var store = Store(
        initialState: AppRootFeature.State(),
        reducer: {
            AppRootFeature()
        }
    )

    @State private var isReady = false

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
