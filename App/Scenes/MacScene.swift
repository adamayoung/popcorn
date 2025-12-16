//
//  MacScene.swift
//  Popcorn
//
//  Created by Adam Young on 05/06/2025.
//

#if os(macOS)
    import ComposableArchitecture
    import SwiftUI

    struct MacScene: Scene {

        @Bindable var store: StoreOf<AppRootFeature>

        private let minWidth: CGFloat = 975
        private let minHeight: CGFloat = 570

        var body: some Scene {
            Window("MOVIES", id: "app") {
                AppRootView(store: store)
                    .frame(
                        minWidth: minWidth,
                        maxWidth: .infinity,
                        minHeight: minHeight,
                        maxHeight: .infinity
                    )
            }
            .windowResizability(.contentSize)
        }

    }

#endif
