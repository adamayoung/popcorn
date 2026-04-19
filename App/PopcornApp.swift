//
//  PopcornApp.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import SwiftUI

@main
struct PopcornApp: App {

    @StateObject private var store: StoreOf<AppRootFeature>

    init() {
        if let epgURL = AppConfig.TVListings.epgURL {
            prepareDependencies { $0.tvListingsEPGURL = epgURL }
        }

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
