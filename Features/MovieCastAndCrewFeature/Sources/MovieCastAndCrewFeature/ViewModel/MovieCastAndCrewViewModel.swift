//
//  MovieCastAndCrewViewModel.swift
//  MovieCastAndCrewFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``MovieCastAndCrewScreen`` once loaded.
public struct MovieCastAndCrewViewSnapshot: Equatable, Sendable {

    public let castMembers: [CastMember]
    public let crewByDepartment: [CrewDepartment]

    public init(
        castMembers: [CastMember],
        crewByDepartment: [CrewDepartment]
    ) {
        self.castMembers = castMembers
        self.crewByDepartment = crewByDepartment
    }

}

/// Drives ``MovieCastAndCrewScreen``. The MVVM replacement for `MovieCastAndCrewFeature`.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
@Observable
@MainActor
public final class MovieCastAndCrewViewModel {

    public typealias ViewSnapshot = MovieCastAndCrewViewSnapshot

    private static let logger = Logger.movieCastAndCrew

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    public let movieID: Int

    private let dependencies: MovieCastAndCrewDependencies
    private let navigator: any MovieCastAndCrewNavigating

    public init(
        movieID: Int,
        dependencies: MovieCastAndCrewDependencies,
        navigator: any MovieCastAndCrewNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.movieID = movieID
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    // MARK: - Lifecycle

    /// Fetches the cast and crew.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``.
    public func load() async {
        await fetch()
    }

    /// Retries loading after an error by changing ``reloadID``, which reruns the
    /// view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Navigation

    public func selectPerson(id: Int, transitionID: String?) {
        navigator.openPersonDetails(id: id, transitionID: transitionID)
    }

    // MARK: - Loading

    func fetch() async {
        guard !viewState.isReady else {
            return
        }
        guard !viewState.isLoading else {
            return
        }

        viewState = .loading
        Self.logger.info(
            "Fetching cast and crew [movieID: \(self.movieID, privacy: .private)]"
        )

        let snapshot: ViewSnapshot
        do {
            let credits = try await dependencies.fetchCredits(movieID)
            snapshot = ViewSnapshot(
                castMembers: credits.castMembers,
                crewByDepartment: credits.crewByDepartment
            )
        } catch {
            Self.logger.error(
                "Failed fetching cast and crew [movieID: \(self.movieID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
            )
            viewState = .error(ViewStateError(error))
            return
        }

        viewState = .ready(snapshot)
    }

}

#if DEBUG
    public extension MovieCastAndCrewViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>
        ) -> MovieCastAndCrewViewModel {
            MovieCastAndCrewViewModel(
                movieID: 0,
                dependencies: .preview,
                navigator: NoOpMovieCastAndCrewNavigator(),
                viewState: viewState
            )
        }

    }
#endif
