//
//  PersonCreditsViewModel.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``PersonCreditsView`` once loaded.
public struct PersonCreditsViewSnapshot: Equatable, Sendable {

    /// The person's credits, newest first.
    public let credits: [CreditItem]

    ///
    /// Creates a new view snapshot.
    ///
    /// - Parameter credits: The person's credits, newest first.
    ///
    public init(credits: [CreditItem]) {
        self.credits = credits
    }

}

/// Drives ``PersonCreditsView``.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
@Observable
@MainActor
public final class PersonCreditsViewModel {

    public typealias ViewSnapshot = PersonCreditsViewSnapshot

    private static let logger = Logger.personCredits

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    /// The identifier of the person whose credits are shown.
    public let personID: Int

    private let dependencies: PersonCreditsDependencies
    private let navigator: any PersonCreditsNavigating

    ///
    /// Creates a new person credits view model.
    ///
    /// - Parameters:
    ///   - personID: The identifier of the person whose credits are shown.
    ///   - dependencies: The view model's data dependencies.
    ///   - navigator: The navigator handling this screen's navigation actions.
    ///   - viewState: The initial view state. Defaults to `.initial`.
    ///
    public init(
        personID: Int,
        dependencies: PersonCreditsDependencies,
        navigator: any PersonCreditsNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.personID = personID
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    // MARK: - Lifecycle

    /// Fetches the person's credits.
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

    /// Opens the details screen for the tapped credit's movie or TV series.
    ///
    /// - Parameter item: The credit that was selected.
    public func selectCredit(_ item: CreditItem) {
        switch item.mediaType {
        case .movie:
            navigator.openMovieDetails(id: item.mediaID)
        case .tvSeries:
            navigator.openTVSeriesDetails(id: item.mediaID)
        }
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
            "Fetching person credits [personID: \(self.personID, privacy: .private)]"
        )

        let snapshot: ViewSnapshot
        do {
            let credits = try await dependencies.fetchCredits(personID)
            snapshot = ViewSnapshot(credits: credits)
        } catch {
            Self.logger.error(
                "Failed fetching person credits [personID: \(self.personID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
            )
            viewState.applyLoadFailure(error)
            return
        }

        viewState = .ready(snapshot)
    }

}

#if DEBUG
    public extension PersonCreditsViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>
        ) -> PersonCreditsViewModel {
            PersonCreditsViewModel(
                personID: 0,
                dependencies: .preview,
                navigator: NoOpPersonCreditsNavigator(),
                viewState: viewState
            )
        }

    }
#endif
