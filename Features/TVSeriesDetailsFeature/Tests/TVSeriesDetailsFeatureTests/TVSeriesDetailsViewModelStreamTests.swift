//
//  TVSeriesDetailsViewModelStreamTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Testing
@testable import TVSeriesDetailsFeature

@Suite("TVSeriesDetailsViewModel Stream Tests")
struct TVSeriesDetailsViewModelStreamTests {

    @Test("a stream update replaces the series while the section stays intact")
    @MainActor
    func streamUpdateReplacesTVSeries() async {
        let base = TVSeriesDetailsViewModelTests.testTVSeries
        let updated = TVSeries(
            id: base.id,
            name: "Updated Series",
            genres: base.genres,
            overview: base.overview,
            seasons: base.seasons
        )

        let viewModel = TVSeriesDetailsViewModelTests.makeViewModel(
            dependencies: TVSeriesDetailsViewModelTests.stubDependencies(
                fetchTVSeries: { _ in base },
                streamTVSeries: { _ in
                    AsyncThrowingStream { continuation in
                        continuation.yield(updated)
                        continuation.finish()
                    }
                },
                fetchCredits: { _ in TVSeriesDetailsViewModelTests.testCredits }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(updated))
        #expect(viewModel.castAndCrewState == .ready(TVSeriesDetailsViewModelTests.testCredits))
    }

    @Test("a nil stream emission leaves the ready series unchanged")
    @MainActor
    func nilStreamEmissionLeavesSeriesUnchanged() async {
        let base = TVSeriesDetailsViewModelTests.testTVSeries

        let viewModel = TVSeriesDetailsViewModelTests.makeViewModel(
            dependencies: TVSeriesDetailsViewModelTests.stubDependencies(
                fetchTVSeries: { _ in base },
                streamTVSeries: { _ in
                    AsyncThrowingStream { continuation in
                        continuation.yield(nil)
                        continuation.finish()
                    }
                }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(base))
    }

    @Test("a stream failure after an update leaves the last good series in place")
    @MainActor
    func streamFailurePreservesLastGoodSeries() async {
        let base = TVSeriesDetailsViewModelTests.testTVSeries
        let updated = TVSeries(
            id: base.id,
            name: "Updated Series",
            genres: base.genres,
            overview: base.overview,
            seasons: base.seasons
        )

        let viewModel = TVSeriesDetailsViewModelTests.makeViewModel(
            dependencies: TVSeriesDetailsViewModelTests.stubDependencies(
                fetchTVSeries: { _ in base },
                streamTVSeries: { _ in
                    AsyncThrowingStream { continuation in
                        continuation.yield(updated)
                        continuation.finish(throwing: StreamTestError.boom)
                    }
                }
            )
        )

        await viewModel.load()

        // The stream error is caught and logged; the last good series stays put.
        #expect(viewModel.viewState == .ready(updated))
    }

}

private enum StreamTestError: Error {
    case boom
}
