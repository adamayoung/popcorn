//
//  PhoneScene.swift
//  Popcorn
//
//  Created by Adam Young on 05/06/2025.
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
