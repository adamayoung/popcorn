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

    /// The MVVM composition root. Builds migrated tabs' view models from the shared
    /// ``AppServices`` graph. TCA tabs still use `store`; both coexist during the
    /// TCA→MVVM migration.
    private let factory: ViewModelFactory

    init() {
        if let epgURL = AppConfig.TVListings.epgURL {
            prepareDependencies { $0.tvListingsEPGURL = epgURL }
        }

        _store = StateObject(wrappedValue: Store(
            initialState: AppRootFeature.State()
        ) {
            AppRootFeature()
        })

        let services: AppServices = if let epgURL = AppConfig.TVListings.epgURL {
            AppServices(tvListingsEPGURL: epgURL)
        } else {
            AppServices()
        }
        self.factory = ViewModelFactory(services: services)
    }

    var body: some Scene {
        #if os(macOS)
            MacScene(store: store, factory: factory)
        #elseif os(visionOS)
            VisionScene(store: store, factory: factory)
        #else
            PhoneScene(store: store, factory: factory)
        #endif
    }

}
