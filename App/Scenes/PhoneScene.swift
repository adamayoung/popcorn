//
//  PhoneScene.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

#if os(iOS)
    import ComposableArchitecture
    import SwiftUI

    struct PhoneScene: Scene {

        @Bindable var store: StoreOf<AppRootFeature>

        var body: some Scene {
            WindowGroup {
                AppRootView(store: store)
                    .preferredColorScheme(.dark)
            }
        }

    }
#endif
