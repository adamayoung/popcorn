//
//  WatchlistRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import MovieCastAndCrewFeature
import MovieDetailsFeature
import MovieIntelligenceFeature
import PersonDetailsFeature
import SwiftUI
import WatchlistFeature

/// The MVVM Watchlist tab root. Hosts the watchlist home in a `NavigationStack`,
/// drives push navigation (movie details, person details, cast and crew) and the
/// movie intelligence modal via ``WatchlistRouter``. The MVVM replacement for the
/// store-based `WatchlistRootView` + `WatchlistRootFeature`.
struct WatchlistRootView: View {

    @Bindable private var router: WatchlistRouter
    private let factory: ViewModelFactory
    private let namespace: Namespace.ID

    /// The home view model, owned here (above the screen seam) so it survives the
    /// router-driven body re-renders that push/present cause. ``WatchlistView``
    /// therefore stores it as a plain `let`. Mirrors how `AppRootView` owns the
    /// TV Listings view model.
    @State private var watchlistViewModel: WatchlistViewModel

    init(
        router: WatchlistRouter,
        factory: ViewModelFactory,
        namespace: Namespace.ID
    ) {
        _router = Bindable(wrappedValue: router)
        self.factory = factory
        self.namespace = namespace
        _watchlistViewModel = State(
            initialValue: factory.makeWatchlist(
                navigator: WatchlistRouterNavigator(router: router)
            )
        )
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            WatchlistView(
                viewModel: watchlistViewModel,
                transitionNamespace: namespace
            )
            .navigationDestination(for: WatchlistRoute.self) { route in
                destination(route)
            }
        }
        .platformModal(item: $router.presentedMovieIntelligence) { intel in
            MovieIntelligenceView(
                viewModel: factory.makeMovieIntelligence(movieID: intel.movieID)
            )
        }
    }

    /// A fresh navigator bound to this view's router. Each destination builds its
    /// own (the navigator is a cheap value type wrapping the shared router).
    private var navigator: WatchlistRouterNavigator {
        WatchlistRouterNavigator(router: router)
    }

    @ViewBuilder
    private func destination(_ route: WatchlistRoute) -> some View {
        switch route {
        case .movieDetails(let id, let transitionID):
            movieDetails(id: id, transitionID: transitionID)
        case .personDetails(let id):
            PersonDetailsView(
                viewModel: factory.makePersonDetails(
                    id: id,
                    navigator: navigator
                )
            )
        case .movieCastAndCrew(let movieID):
            MovieCastAndCrewView(
                viewModel: factory.makeMovieCastAndCrew(
                    movieID: movieID,
                    navigator: navigator
                )
            )
        }
    }

    @ViewBuilder
    private func movieDetails(id: Int, transitionID: String?) -> some View {
        let viewModel = factory.makeMovieDetails(
            id: id,
            transitionID: transitionID,
            navigator: navigator
        )
        if let transitionID {
            MovieDetailsView(viewModel: viewModel)
            #if os(iOS)
                .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            MovieDetailsView(viewModel: viewModel)
        }
    }

}
