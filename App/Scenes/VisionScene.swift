//
//  VisionScene.swift
//  Popcorn
//
//  Created by Adam Young on 05/06/2025.
//

#if os(visionOS)
    import ComposableArchitecture
    import SwiftUI

    struct VisionScene: Scene {

        @Bindable var store: StoreOf<AppRootFeature>

        private let minWidth: CGFloat = 1280
        private let minHeight: CGFloat = 720

        var body: some Scene {
            WindowGroup("MOVIES", id: "app") {
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
                .onAppear {
                    if let windowScene = UIApplication.shared.connectedScenes.first
                        as? UIWindowScene
                    {
                        let geometryPreferences = UIWindowScene.GeometryPreferences.Vision(
                            resizingRestrictions: .uniform
                        )
                        windowScene.requestGeometryUpdate(geometryPreferences)
                    }
                }
            }
            .windowStyle(.plain)
            .windowResizability(.contentMinSize)
            .defaultSize(width: minWidth, height: minHeight)
        }

    }
#endif
