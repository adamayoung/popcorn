//
//  TVSeriesDetailsFeature.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import OSLog
import TCAFoundation

@Reducer
public struct TVSeriesDetailsFeature: Sendable {

    private static let logger = Logger.tvSeriesDetails

    @Dependency(\.tvSeriesDetailsClient) private var client

    @ObservableState
    public struct State: Sendable, Equatable {
        var tvSeriesID: Int
        public let transitionID: String?
        public var viewState: ViewState<ViewSnapshot>
        public var isIntelligenceEnabled: Bool
        public var isBackdropFocalPointEnabled: Bool

        public init(
            tvSeriesID: Int,
            transitionID: String? = nil,
            viewState: ViewState<ViewSnapshot> = .initial,
            isIntelligenceEnabled: Bool = false,
            isBackdropFocalPointEnabled: Bool = false
        ) {
            self.tvSeriesID = tvSeriesID
            self.transitionID = transitionID
            self.viewState = viewState
            self.isIntelligenceEnabled = isIntelligenceEnabled
            self.isBackdropFocalPointEnabled = isBackdropFocalPointEnabled
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
        public let tvSeries: TVSeries

        public init(tvSeries: TVSeries) {
            self.tvSeries = tvSeries
        }
    }

    public enum Action {
        case didAppear
        case updateFeatureFlags
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(ViewStateError)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case tvSeriesIntelligence(id: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                return .run { send in
                    await send(.updateFeatureFlags)
                }

            case .updateFeatureFlags:
                state.isIntelligenceEnabled = (try? client.isIntelligenceEnabled()) ?? false
                state.isBackdropFocalPointEnabled = (try? client.isBackdropFocalPointEnabled()) ?? false
                return .none

            case .fetch:
                if state.viewState.isReady {
                    state.viewState = .loading
                }

                return handleFetchTVSeries(&state)

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none

            default:
                return .none
            }
        }
    }

}

extension TVSeriesDetailsFeature {

    private func handleFetchTVSeries(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            Self.logger.info(
                "User fetching TV series [tvSeriesID: \(state.tvSeriesID, privacy: .private)]"
            )

            let tvSeries: TVSeries
            do {
                tvSeries = try await client.fetchTVSeries(state.tvSeriesID)
            } catch {
                Self.logger.error(
                    "Failed fetching TV series [tvSeriesID: \(state.tvSeriesID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            let snapshot = ViewSnapshot(tvSeries: tvSeries)
            await send(.loaded(snapshot))
        }
    }
}
