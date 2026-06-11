//
//  TVListingsViewModelTestHelpers.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Synchronization
import TVListingsDomain
@testable import TVListingsFeature

// MARK: - Async Gate

/// A one-shot gate used to hold a stubbed async closure mid-flight so a test can
/// observe in-flight state, then release it.
final class AsyncGate: Sendable {

    private let state = Mutex(State())

    private struct State {
        var isOpen = false
        var isWaiting = false
        var resume: (@Sendable () -> Void)?
    }

    /// Suspends until ``open()`` is called. Records that a caller is waiting so a
    /// test can synchronise on it via ``waitUntilWaiting()``.
    func wait() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            let shouldResumeImmediately = state.withLock { state -> Bool in
                if state.isOpen {
                    return true
                }
                state.isWaiting = true
                state.resume = { continuation.resume() }
                return false
            }
            if shouldResumeImmediately {
                continuation.resume()
            }
        }
    }

    /// Releases the suspended ``wait()``.
    func open() {
        let resume = state.withLock { state -> (@Sendable () -> Void)? in
            state.isOpen = true
            let resume = state.resume
            state.resume = nil
            return resume
        }
        resume?()
    }

    /// Polls until a caller is suspended inside ``wait()``.
    func waitUntilWaiting() async {
        while !state.withLock(\.isWaiting) {
            await Task.yield()
        }
    }

}

// MARK: - Factories

extension TVListingsViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TVListingsDependencies = stubDependencies(),
        now: @escaping @Sendable () -> Date = { Date(timeIntervalSince1970: 1500) },
        viewState: ViewState<TVListingsGridSnapshot> = .initial
    ) -> TVListingsViewModel {
        TVListingsViewModel(dependencies: dependencies, now: now, viewState: viewState)
    }

    static func stubDependencies(
        fetchChannels: @escaping @Sendable () async throws -> [TVChannel] = { [] },
        fetchListings: @escaping @Sendable () async throws -> [TVProgramme] = { [] }
    ) -> TVListingsDependencies {
        TVListingsDependencies(
            fetchChannels: fetchChannels,
            fetchListings: fetchListings
        )
    }

    /// The rows of a `.ready` snapshot, or an empty array if the view model is not ready.
    @MainActor
    static func readyRows(_ viewModel: TVListingsViewModel) -> [TVListingsChannelRow] {
        guard case .ready(let snapshot) = viewModel.viewState else {
            return []
        }
        return snapshot.rows
    }

}

// MARK: - Test Data

extension TVListingsViewModelTests {

    static func makeChannel(id: String, name: String) -> TVChannel {
        TVChannel(id: id, name: name, isHD: false, logoURL: nil, channelNumbers: [])
    }

    static func makeProgramme(
        id: String,
        channelID: String,
        title: String,
        start: TimeInterval = 1000,
        end: TimeInterval = 1900,
        duration: TimeInterval = 900,
        genres: [String] = []
    ) -> TVProgramme {
        TVProgramme(
            id: id,
            channelID: channelID,
            title: title,
            description: "",
            startTime: Date(timeIntervalSince1970: start),
            endTime: Date(timeIntervalSince1970: end),
            duration: duration,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil,
            genres: genres
        )
    }

}
