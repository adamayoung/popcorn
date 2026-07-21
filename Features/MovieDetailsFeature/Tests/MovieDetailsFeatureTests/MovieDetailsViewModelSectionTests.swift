//
//  MovieDetailsViewModelSectionTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import MovieDetailsFeature
import Presentation
import Synchronization
import Testing

/// Covers the independently-loaded section states (feature-flag gating and the
/// load re-entry guards). Shares the fixtures defined on ``MovieDetailsViewModelTests``.
@Suite("MovieDetailsViewModel Section Tests")
struct MovieDetailsViewModelSectionTests {

    private typealias Fixtures = MovieDetailsViewModelTests

    // MARK: - Feature flags

    @Test("disabled section flags leave the sections initial and skip their dependencies")
    @MainActor
    func disabledSectionFlagsSkipDependencies() async {
        let recommendedCalled = Mutex(false)
        let creditsCalled = Mutex(false)
        let viewModel = Fixtures.makeViewModel(
            dependencies: Fixtures.stubDependencies(
                fetchMovie: { _ in Fixtures.testMovie },
                fetchRecommendedMovies: { _ in recommendedCalled.withLock { $0 = true }; return [] },
                fetchCredits: { _ in
                    creditsCalled.withLock { $0 = true }
                    return Fixtures.testCredits
                },
                isCastAndCrewEnabled: { false },
                isRecommendedMoviesEnabled: { false }
            )
        )

        await viewModel.load()

        #expect(recommendedCalled.withLock { $0 } == false)
        #expect(creditsCalled.withLock { $0 } == false)
        #expect(viewModel.recommendedMoviesState.isInitial)
        #expect(viewModel.castAndCrewState.isInitial)
    }

    @Test("a flag turning off resets a previously ready section to initial")
    @MainActor
    func flagTurningOffResetsSection() async {
        let viewModel = Fixtures.makeViewModel(
            dependencies: Fixtures.stubDependencies(isCastAndCrewEnabled: { false }),
            castAndCrewState: .ready(Fixtures.testCredits)
        )

        await viewModel.loadCastAndCrew()

        #expect(viewModel.castAndCrewState.isInitial)
    }

    // MARK: - Re-entry guards

    @Test("a cancelled section load resets to initial and reloads on the next run")
    @MainActor
    func cancelledSectionReloadsOnNextRun() async {
        let callCount = Mutex(0)
        let viewModel = Fixtures.makeViewModel(
            dependencies: Fixtures.stubDependencies(
                fetchRecommendedMovies: { _ in
                    let attempt = callCount.withLock { $0 += 1; return $0 }
                    if attempt == 1 {
                        throw CancellationError()
                    }
                    return Fixtures.testRecommendations
                }
            )
        )

        await viewModel.loadRecommendedMovies()
        #expect(viewModel.recommendedMoviesState.isInitial)

        await viewModel.loadRecommendedMovies()
        #expect(viewModel.recommendedMoviesState == .ready(Fixtures.testRecommendations))
    }

    @Test("a section load is a no-op when the section is already ready")
    @MainActor
    func sectionLoadNoOpWhenReady() async {
        let called = Mutex(false)
        let viewModel = Fixtures.makeViewModel(
            dependencies: Fixtures.stubDependencies(
                fetchRecommendedMovies: { _ in called.withLock { $0 = true }; return [] }
            ),
            recommendedMoviesState: .ready(Fixtures.testRecommendations)
        )

        await viewModel.loadRecommendedMovies()

        #expect(called.withLock { $0 } == false)
        #expect(viewModel.recommendedMoviesState == .ready(Fixtures.testRecommendations))
    }

    @Test("a section load is a no-op when the section is already loading")
    @MainActor
    func sectionLoadNoOpWhenLoading() async {
        let called = Mutex(false)
        let viewModel = Fixtures.makeViewModel(
            dependencies: Fixtures.stubDependencies(
                fetchCredits: { _ in
                    called.withLock { $0 = true }
                    return Fixtures.testCredits
                }
            ),
            castAndCrewState: .loading
        )

        await viewModel.loadCastAndCrew()

        #expect(called.withLock { $0 } == false)
        #expect(viewModel.castAndCrewState.isLoading)
    }

}
