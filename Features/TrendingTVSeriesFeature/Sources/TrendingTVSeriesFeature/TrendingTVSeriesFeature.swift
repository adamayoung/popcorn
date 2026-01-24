//
//  TrendingTVSeriesFeature.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog

@Reducer
public struct TrendingTVSeriesFeature: Sendable {

    private static let logger = Logger.trendingTVSeries

    @Dependency(\.trendingTVSeriesClient) private var client

    @ObservableState
    public struct State {
        var tvSeries: [TVSeriesPreview]

        public init(tvSeries: [TVSeriesPreview] = []) {
            self.tvSeries = tvSeries
        }
    }

    public enum Action {
        case loadTrendingTVSeries
        case trendingTVSeriesLoaded([TVSeriesPreview])
        case loadTrendingTVSeriesFailed(Error)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case tvSeriesDetails(id: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadTrendingTVSeries:
                return handleFetchTrendingTVSeries()
            case .trendingTVSeriesLoaded(let tvSeries):
                state.tvSeries = tvSeries
                return .none
            case .loadTrendingTVSeriesFailed:
                return .none
            case .navigate:
                return .none
            }
        }
    }

}

private extension TrendingTVSeriesFeature {

    func handleFetchTrendingTVSeries() -> EffectOf<Self> {
        .run { [client] send in
            Self.logger.info("User fetching trending TV series")

            let tvSeries: [TVSeriesPreview]
            do {
                tvSeries = try await client.fetchTrendingTVSeries()
            } catch let error {
                Self.logger.error(
                    "Failed fetching trending TV series: \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadTrendingTVSeriesFailed(error))
                return
            }

            await send(.trendingTVSeriesLoaded(tvSeries))
        }
    }

}
