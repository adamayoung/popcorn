//
//  TVSeriesDetailsFeature.swift
//  TVSeriesDetailsFeature
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import OSLog

@Reducer
public struct TVSeriesDetailsFeature: Sendable {

    @Dependency(\.tvSeriesDetailsClient) private var tvSeriesDetailsClient

    private static let logger = Logger(
        subsystem: "TVSeriesDetailsFeature",
        category: "TVSeriesDetailsFeatureReducer"
    )

    @ObservableState
    public struct State: Sendable {
        var tvSeriesID: Int
        public let transitionID: String?
        public var viewState: ViewState

        public var isLoading: Bool {
            switch viewState {
            case .loading: true
            default: false
            }
        }

        public var isReady: Bool {
            switch viewState {
            case .ready: true
            default: false
            }
        }

        public init(
            tvSeriesID: Int,
            transitionID: String? = nil,
            viewState: ViewState = .initial
        ) {
            self.tvSeriesID = tvSeriesID
            self.transitionID = transitionID
            self.viewState = viewState
        }
    }

    public enum ViewState: Sendable {
        case initial
        case loading
        case ready(ViewSnapshot)
        case error(Error)
    }

    public struct ViewSnapshot: Sendable {
        public let tvSeries: TVSeries

        public init(tvSeries: TVSeries) {
            self.tvSeries = tvSeries
        }
    }

    public enum Action {
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(Error)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetch:
                if state.isReady {
                    state.viewState = .loading
                }

                return handleFetchTVSeries(&state)

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none
            }
        }
    }

}

extension TVSeriesDetailsFeature {

    private func handleFetchTVSeries(_ state: inout State) -> EffectOf<Self> {
        .run { [state] send in
            do {
                let tvSeries = try await tvSeriesDetailsClient.fetch(state.tvSeriesID)
                let snapshot = ViewSnapshot(tvSeries: tvSeries)
                await send(.loaded(snapshot))
            } catch {
                Self.logger.error("Failed fetching TV series: \(error.localizedDescription)")
                await send(.loadFailed(error))
            }
        }
    }
}
