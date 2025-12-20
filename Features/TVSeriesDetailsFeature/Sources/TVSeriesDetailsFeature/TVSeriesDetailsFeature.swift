//
//  TVSeriesDetailsFeature.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import Observability
import OSLog

@Reducer
public struct TVSeriesDetailsFeature: Sendable {

    private static let logger = Logger.tvSeriesDetails

    @Dependency(\.tvSeriesDetailsClient) private var tvSeriesDetailsClient
    @Dependency(\.observability) private var observability

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
        .run { [state, observability, tvSeriesDetailsClient] send in
            Self.logger.info(
                "User fetching TV series [tvSeriesID: \(state.tvSeriesID, privacy: .private)]")

            let transaction = observability.startTransaction(
                name: "FetchTVSeriesDetails",
                operation: .uiAction
            )
            transaction.setData(key: "tv_series_id", value: state.tvSeriesID)

            do {
                let tvSeries = try await tvSeriesDetailsClient.fetch(state.tvSeriesID)
                let snapshot = ViewSnapshot(tvSeries: tvSeries)
                transaction.finish()
                await send(.loaded(snapshot))
            } catch {
                Self.logger.error(
                    "Failed fetching TV series [tvSeriesID: \(state.tvSeriesID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
                )
                transaction.setData(error: error)
                transaction.finish(status: .internalError)
                await send(.loadFailed(error))
            }
        }
    }
}
