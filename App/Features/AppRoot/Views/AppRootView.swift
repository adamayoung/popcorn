//
//  AppRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
#if DEBUG
    import DeveloperFeature
#endif
import DesignSystem
import SwiftUI
import TVListingsFeature
import WatchlistFeature

struct AppRootView: View {

    @State private var viewModel: AppRootViewModel
    let factory: ViewModelFactory

    @State private var customization = TabViewCustomization()
    @State private var exploreRouter = ExploreRouter()
    @Namespace private var exploreNamespace
    @State private var gamesRouter = GamesRouter()
    @Namespace private var gamesNamespace
    @State private var watchlistRouter = WatchlistRouter()
    @Namespace private var watchlistNamespace
    @State private var searchRouter = SearchRouter()
    @Namespace private var searchNamespace
    @State private var tvListingsViewModel: TVListingsViewModel

    init(viewModel: AppRootViewModel, factory: ViewModelFactory) {
        _viewModel = State(initialValue: viewModel)
        self.factory = factory
        _tvListingsViewModel = State(initialValue: factory.makeTVListings())
    }

    var body: some View {
        Group {
            if viewModel.isReady {
                content
            } else if let error = viewModel.error {
                errorView(with: error)
            } else {
                ProgressView()
                    .accessibilityLabel(Text("LOADING"))
            }
        }
        #if DEBUG
        .sheet(isPresented: $viewModel.isPresentingDeveloper) {
                DeveloperView(makeFeatureFlags: { factory.makeFeatureFlags() })
            }
        #endif
        #if DEBUG && os(iOS)
        .onShake {
            viewModel.presentDeveloper()
        }
        #endif
        .task {
                await viewModel.start()
            }
    }

    private var content: some View {
        TabView(selection: $viewModel.selectedTab) {
            if viewModel.isExploreEnabled {
                Tab(
                    "EXPLORE",
                    systemImage: "popcorn",
                    value: AppRootViewModel.Tab.explore
                ) {
                    ExploreRootView(
                        router: exploreRouter,
                        factory: factory,
                        namespace: exploreNamespace
                    )
                }
                .customizationID(AppRootViewModel.Tab.explore.id)
                .accessibilityIdentifier("app.tabview.explore")
            }

            if viewModel.isWatchlistEnabled {
                Tab(
                    "WATCHLIST",
                    systemImage: "eye",
                    value: AppRootViewModel.Tab.watchlist
                ) {
                    WatchlistRootView(
                        router: watchlistRouter,
                        factory: factory,
                        namespace: watchlistNamespace
                    )
                }
                .customizationID(AppRootViewModel.Tab.watchlist.id)
                .accessibilityIdentifier("app.tabview.watchlist")
            }

            if viewModel.isGamesEnabled {
                Tab(
                    "GAMES",
                    systemImage: "flag.and.flag.filled.crossed",
                    value: AppRootViewModel.Tab.games
                ) {
                    GamesRootView(
                        router: gamesRouter,
                        factory: factory,
                        namespace: gamesNamespace
                    )
                }
                .customizationID(AppRootViewModel.Tab.games.id)
                .accessibilityIdentifier("app.tabview.games")
            }

            if viewModel.isTVListingsEnabled {
                Tab(
                    "TV_LISTINGS",
                    systemImage: "tv",
                    value: AppRootViewModel.Tab.tvListings
                ) {
                    TVListingsRootView(viewModel: tvListingsViewModel)
                }
                .customizationID(AppRootViewModel.Tab.tvListings.id)
                .accessibilityIdentifier("app.tabview.tvlistings")
            }

            if viewModel.isSearchEnabled {
                Tab(
                    "SEARCH",
                    systemImage: "magnifyingglass",
                    value: AppRootViewModel.Tab.search,
                    role: .search
                ) {
                    SearchRootView(
                        router: searchRouter,
                        factory: factory,
                        namespace: searchNamespace
                    )
                }
                .customizationID(AppRootViewModel.Tab.search.id)
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
        viewModel: AppRootViewModel(dependencies: .preview),
        factory: ViewModelFactory(services: AppServices())
    )
}
