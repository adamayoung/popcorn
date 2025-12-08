//
//  MacScene.swift
//  Popcorn
//
//  Created by Adam Young on 05/06/2025.
//

#if os(macOS)
    import ComposableArchitecture
    import FeatureFlagsAdapters
    import SwiftUI

    struct MacScene: Scene {

        @Bindable var store: StoreOf<AppRootFeature>

        private let minWidth: CGFloat = 975
        private let minHeight: CGFloat = 570
        @State private var isReady = true

        var body: some Scene {
            Window("MOVIES", id: "app") {
                Group {
                    if isReady {
                        AppRootView(store: store)
                    } else {
                        EmptyView()
                    }
                }
                .frame(
                    minWidth: minWidth,
                    maxWidth: .infinity,
                    minHeight: minHeight,
                    maxHeight: .infinity
                )
                .task {
                    await initialiseFeatureFlags()
                }

            }
            .windowResizability(.contentSize)
        }

    }

    extension MacScene {

        private func initialiseFeatureFlags() async {
            try? await StatsigFeatureFlagInitialiser.start(
                config: .init(
                    userID: (FileManager.default.ubiquityIdentityToken?.description
                        ?? UUID().uuidString),
                    environment: AppConfig.statsigEnvironment,
                    apiKey: AppConfig.statsigKey
                )
            )
            isReady = true
        }

    }

#endif
