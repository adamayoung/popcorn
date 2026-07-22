//
//  PersonDetailsViewModel.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``PersonDetailsView`` once loaded.
public struct PersonDetailsViewSnapshot: Equatable, Sendable {

    public let person: Person

    public init(person: Person) {
        self.person = person
    }

}

/// Drives ``PersonDetailsView``.
///
/// Loading is driven by the view through ``load()`` from a `.task(id:)`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on reappear
/// (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the fetch tied to the
/// view's lifetime with no manual cancellation.
///
/// Person details is a one-shot fetch: there is no live stream and no watchlist toggle.
@Observable
@MainActor
public final class PersonDetailsViewModel {

    public typealias ViewSnapshot = PersonDetailsViewSnapshot

    private static let logger = Logger.personDetails

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// The "Known For" carousel's state, loaded after the person is ready and
    /// degrading independently so an auxiliary failure never blanks the screen.
    public private(set) var knownForState: ViewState<[KnownForItem]>

    public private(set) var isFocalPointEnabled: Bool

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    public let personID: Int
    public let transitionID: String?

    private let dependencies: PersonDetailsDependencies
    private let navigator: any PersonDetailsNavigating

    public init(
        personID: Int,
        transitionID: String? = nil,
        dependencies: PersonDetailsDependencies,
        navigator: any PersonDetailsNavigating,
        viewState: ViewState<ViewSnapshot> = .initial,
        knownForState: ViewState<[KnownForItem]> = .initial,
        isFocalPointEnabled: Bool = false
    ) {
        self.personID = personID
        self.transitionID = transitionID
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
        self.knownForState = knownForState
        self.isFocalPointEnabled = isFocalPointEnabled
    }

    // MARK: - Lifecycle

    public func didAppear() {
        updateFeatureFlags()
    }

    public func updateFeatureFlags() {
        isFocalPointEnabled = (try? dependencies.isFocalPointEnabled()) ?? false
    }

    /// Fetches the person details, then loads the "Known For" section.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``. The section loads only once the
    /// person is ready, so its latency never delays the primary content.
    public func load() async {
        await fetch()
        guard viewState.isReady else {
            return
        }

        await loadKnownFor()
    }

    /// Retries loading after an error by changing ``reloadID``, which reruns the
    /// view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Navigation

    /// Opens the movie or TV series a tapped "Known For" item refers to.
    public func selectKnownForItem(_ item: KnownForItem) {
        switch item.mediaType {
        case .movie:
            navigator.openMovieDetails(id: item.id)
        case .tvSeries:
            navigator.openTVSeriesDetails(id: item.id)
        }
    }

    /// Opens the person's full credits list from the "Known For" section header.
    public func selectKnownFor() {
        navigator.openPersonCredits(personID: personID)
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
            "User fetching person [personID: \"\(self.personID, privacy: .private)\"]"
        )

        let snapshot: ViewSnapshot
        do {
            let person = try await dependencies.fetchPerson(personID)
            snapshot = ViewSnapshot(person: person)
        } catch {
            Self.logger.error(
                "Failed fetching person details: [personID: \"\(self.personID, privacy: .private)\"] \(error.localizedDescription, privacy: .public)"
            )
            viewState.applyLoadFailure(error)
            return
        }

        viewState = .ready(snapshot)
    }

    func loadKnownFor() async {
        guard !knownForState.isReady, !knownForState.isLoading else {
            return
        }

        knownForState = .loading
        do {
            let items = try await dependencies.fetchKnownFor(personID)
            knownForState = .ready(items)
        } catch {
            Self.logger.error(
                "Failed fetching known for: [personID: \"\(self.personID, privacy: .private)\"] \(error.localizedDescription, privacy: .public)"
            )
            knownForState.applyLoadFailure(error)
        }
    }

}

#if DEBUG
    public extension PersonDetailsViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot>,
            knownForState: ViewState<[KnownForItem]> = .initial,
            isFocalPointEnabled: Bool = false
        ) -> PersonDetailsViewModel {
            PersonDetailsViewModel(
                personID: viewState.content?.person.id ?? 0,
                dependencies: .preview,
                navigator: NoOpPersonDetailsNavigator(),
                viewState: viewState,
                knownForState: knownForState,
                isFocalPointEnabled: isFocalPointEnabled
            )
        }

    }
#endif
