//
//  TrendingTVSeriesFeature.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import Observability
import OSLog

@Reducer
public struct TrendingTVSeriesFeature: Sendable {

    private static let logger = Logger.trendingTVSeries

    @Dependency(\.trendingTVSeries) private var trendingTVSeries
    @Dependency(\.observability) private var observability

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
        .run { send in
            Self.logger.info("User fetching trending TV series")

            let transaction = observability.startTransaction(
                name: "FetchTrendingTVSeries",
                operation: .uiAction
            )

            do {
                let tvSeries = try await trendingTVSeries.fetch()
                transaction.finish()
                await send(.trendingTVSeriesLoaded(tvSeries))
            } catch let error {
                Self.logger.error(
                    "Failed fetching trending TV series: \(error.localizedDescription, privacy: .public)"
                )
                transaction.setData(error: error)
                transaction.finish(status: .internalError)
                await send(.loadTrendingTVSeriesFailed(error))
            }
        }
    }

}
