//
//  VisionScene.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

#if os(visionOS)
    import ComposableArchitecture
    import SwiftUI
    import UIKit

    struct VisionScene: Scene {

        @Bindable var store: StoreOf<AppRootFeature>

        private let minWidth: CGFloat = 1280
        private let minHeight: CGFloat = 720

        var body: some Scene {
            WindowGroup("MOVIES", id: "app") {
                AppRootView(store: store)
                    .preferredColorScheme(.dark)
                    .onAppear {
                        if let windowScene = UIApplication.shared.connectedScenes.first
                            as? UIWindowScene {
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
