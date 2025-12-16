//
//  AppRootView.swift
//  Popcorn
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import SwiftUI

struct AppRootView: View {

    @Bindable var store: StoreOf<AppRootFeature>
    @State private var customization = TabViewCustomization()

    var body: some View {
        Group {
            if store.isReady {
                content
            } else if let error = store.error {
                errorView(with: error)
            } else {
                ProgressView()
            }
        }
        .task {
            store.send(.didAppear)
        }
    }

    private var content: some View {
        TabView(selection: $store.selectedTab) {
            if store.isExploreEnabled {
                Tab(
                    "EXPLORE",
                    systemImage: "popcorn",
                    value: AppRootFeature.Tab.explore
                ) {
                    ExploreRootView(
                        store: store.scope(
                            state: \.explore,
                            action: \.explore
                        )
                    )
                }
                .customizationID(AppRootFeature.Tab.explore.id)
            }

            if store.isGamesEnabled {
                Tab(
                    "GAMES",
                    systemImage: "flag.and.flag.filled.crossed",
                    value: AppRootFeature.Tab.games
                ) {
                    GamesRootView(
                        store: store.scope(
                            state: \.games,
                            action: \.games
                        )
                    )
                }
                .customizationID(AppRootFeature.Tab.games.id)
            }

            if store.isSearchEnabled {
                Tab(
                    "SEARCH",
                    systemImage: "magnifyingglass",
                    value: AppRootFeature.Tab.search,
                    role: .search
                ) {
                    SearchRootView(
                        store: store.scope(
                            state: \.search,
                            action: \.search
                        )
                    )
                }
                .customizationID(AppRootFeature.Tab.search.id)
            }
        }
        #if !os(macOS)
            .tabViewStyle(.sidebarAdaptable)
            .tabViewCustomization($customization)
        #else
            .tabViewStyle(.sidebarAdaptable)
            .tabViewCustomization($customization)
        #endif
        .minimizeTabBar()
    }

    private func errorView(with error: Error) -> some View {
        ContentUnavailableView(
            "FAILED_TO_LOAD",
            systemImage: "exclamationmark.triangle.fill",
            description: Text("APP_FAILED_TO_START_TRY_AGAIN")
        )

    }

}

extension View {

    @ViewBuilder fileprivate func minimizeTabBar() -> some View {
        #if os(iOS)
            if #available(iOS 26.0, *) {
                self.tabBarMinimizeBehavior(.onScrollDown)
            } else {
                self
            }
        #else
            self
        #endif
    }

}

#Preview {
    AppRootView(
        store: Store(
            initialState: AppRootFeature.State(),
            reducer: {
                AppRootFeature()
            }
        )
    )
}
