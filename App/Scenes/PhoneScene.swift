//
//  PhoneScene.swift
//  Popcorn
//
//  Created by Adam Young on 05/06/2025.
//

#if os(iOS)
    import ComposableArchitecture
    import FeatureFlagsAdapters
    import SwiftUI

    struct PhoneScene: Scene {

        @Bindable var store: StoreOf<AppRootFeature>
        @State private var isReady = false

        var body: some Scene {
            WindowGroup {
                Group {
                    if isReady {
                        AppRootView(store: store)
                    } else {
                        EmptyView()
                    }
                }
                .preferredColorScheme(.dark)
                .task {
                    await initialiseFeatureFlags()
                }
            }
        }

    }

    extension PhoneScene {

        private func initialiseFeatureFlags() async {
            try? await StatsigFeatureFlagInitialiser.start(
                config: .init(
                    userID: (UIDevice.current.identifierForVendor ?? UUID()).uuidString,
                    environment: AppConfig.statsigEnvironment,
                    apiKey: AppConfig.statsigKey
                )
            )
            isReady = true
        }

    }
#endif
