//
//  TrendingTVSeriesViewModelTests.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TrendingTVSeriesFeature

@Suite("TrendingTVSeriesViewModel Tests")
struct TrendingTVSeriesViewModelTests {

    @Test("load success populates tvSeries")
    @MainActor
    func loadSuccessPopulatesTVSeries() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchTrendingTVSeries: { Self.testTVSeries })
        )

        await viewModel.load()

        #expect(viewModel.tvSeries == Self.testTVSeries)
    }

    @Test("load failure leaves tvSeries unchanged")
    @MainActor
    func loadFailureLeavesTVSeriesUnchanged() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchTrendingTVSeries: { throw TestError.generic }),
            tvSeries: Self.testTVSeries
        )

        await viewModel.load()

        #expect(viewModel.tvSeries == Self.testTVSeries)
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel()
        let initialReloadID = viewModel.reloadID

        viewModel.reload()

        #expect(viewModel.reloadID == initialReloadID + 1)
    }

    @Test("selectTVSeries invokes the navigator with the correct identifier")
    @MainActor
    func selectTVSeriesInvokesNavigator() {
        let navigator = SpyTrendingTVSeriesNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectTVSeries(id: 456)

        #expect(navigator.openedTVSeriesID == 456)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyTrendingTVSeriesNavigator: TrendingTVSeriesNavigating {
    var openedTVSeriesID: Int?

    func openTVSeriesDetails(id: Int) {
        openedTVSeriesID = id
    }
}

// MARK: - Factories

extension TrendingTVSeriesViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TrendingTVSeriesDependencies = stubDependencies(),
        navigator: any TrendingTVSeriesNavigating = SpyTrendingTVSeriesNavigator(),
        tvSeries: [TVSeriesPreview] = []
    ) -> TrendingTVSeriesViewModel {
        TrendingTVSeriesViewModel(
            dependencies: dependencies,
            navigator: navigator,
            tvSeries: tvSeries
        )
    }

    static func stubDependencies(
        fetchTrendingTVSeries: @escaping @Sendable () async throws -> [TVSeriesPreview] = { [] }
    ) -> TrendingTVSeriesDependencies {
        TrendingTVSeriesDependencies(fetchTrendingTVSeries: fetchTrendingTVSeries)
    }

}

// MARK: - Test Data

extension TrendingTVSeriesViewModelTests {

    static let testTVSeries = [
        TVSeriesPreview(id: 1, name: "Series 1"),
        TVSeriesPreview(id: 2, name: "Series 2")
    ]

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
