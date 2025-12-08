//
//  TrendingTVSeriesFeature.swift
//  TrendingTVSeriesFeature
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TrendingTVSeriesFeature: Sendable {

    @Dependency(\.trendingTVSeries) private var trendingTVSeries: TrendingTVSeriesClient

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
            case .navigate:
                return .none
            }
        }
    }

}

extension TrendingTVSeriesFeature {

    fileprivate func handleFetchTrendingTVSeries() -> EffectOf<Self> {
        .run { send in
            do {
                let tvSeries = try await trendingTVSeries.fetch()
                await send(.trendingTVSeriesLoaded(tvSeries))
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

}
