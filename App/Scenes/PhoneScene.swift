//
//  PhoneScene.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

#if os(iOS)
    import ComposableArchitecture
    import SwiftUI

    struct PhoneScene: Scene {

        @Bindable var store: StoreOf<AppRootFeature>
        let factory: ViewModelFactory

        var body: some Scene {
            WindowGroup {
                AppRootView(store: store, factory: factory)
            }
        }

    }
#endif
