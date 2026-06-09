//
//  AppRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import DesignSystem
#if DEBUG
    import DeveloperFeature
#endif
import SwiftUI
import TVListingsFeature
import WatchlistFeature

struct AppRootView: View {

    @Bindable var store: StoreOf<AppRootFeature>
    let factory: ViewModelFactory

    @State private var customization = TabViewCustomization()
    @State private var gamesRouter = GamesRouter()
    @Namespace private var gamesNamespace
    @State private var watchlistRouter = WatchlistRouter()
    @Namespace private var watchlistNamespace
    @State private var tvListingsViewModel: TVListingsViewModel

    init(store: StoreOf<AppRootFeature>, factory: ViewModelFactory) {
        _store = Bindable(wrappedValue: store)
        self.factory = factory
        _tvListingsViewModel = State(initialValue: factory.makeTVListings())
    }

    var body: some View {
        Group {
            if store.isReady {
                content
            } else if let error = store.error {
                errorView(with: error)
            } else {
                ProgressView()
                    .accessibilityLabel(Text("LOADING"))
            }
        }
        #if DEBUG
        .sheet(
                item: $store.scope(
                    state: \.developer,
                    action: \.developer
                )
            ) { store in
                DeveloperView(store: store)
            }
        #endif
        #if DEBUG && os(iOS)
        .onShake {
            store.send(.navigate(.developer))
        }
        #endif
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
                .accessibilityIdentifier("app.tabview.explore")
            }

            if store.isWatchlistEnabled {
                Tab(
                    "WATCHLIST",
                    systemImage: "eye",
                    value: AppRootFeature.Tab.watchlist
                ) {
                    WatchlistRootView(
                        router: watchlistRouter,
                        factory: factory,
                        namespace: watchlistNamespace
                    )
                }
                .customizationID(AppRootFeature.Tab.watchlist.id)
                .accessibilityIdentifier("app.tabview.watchlist")
            }

            if store.isGamesEnabled {
                Tab(
                    "GAMES",
                    systemImage: "flag.and.flag.filled.crossed",
                    value: AppRootFeature.Tab.games
                ) {
                    GamesRootView(
                        router: gamesRouter,
                        factory: factory,
                        namespace: gamesNamespace
                    )
                }
                .customizationID(AppRootFeature.Tab.games.id)
                .accessibilityIdentifier("app.tabview.games")
            }

            if store.isTVListingsEnabled {
                Tab(
                    "TV_LISTINGS",
                    systemImage: "tv",
                    value: AppRootFeature.Tab.tvListings
                ) {
                    TVListingsRootView(viewModel: tvListingsViewModel)
                }
                .customizationID(AppRootFeature.Tab.tvListings.id)
                .accessibilityIdentifier("app.tabview.tvlistings")
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
                .accessibilityIdentifier("app.tabview.search")
            }
        }
        .accessibilityIdentifier("app.tabview")
        #if os(macOS)
            .tabViewStyle(.automatic)
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

private extension View {

    @ViewBuilder
    func minimizeTabBar() -> some View {
        #if os(iOS)
            if #available(iOS 26.0, *) {
                tabBarMinimizeBehavior(.onScrollDown)
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
        ),
        factory: ViewModelFactory(services: AppServices())
    )
}
