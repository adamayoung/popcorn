//
//  TVSeriesDetailsFeature.swift
//  TVSeriesDetailsFeature
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TVSeriesDetailsFeature: Sendable {

    @Dependency(\.tvSeriesDetails) private var tvSeriesDetails: TVSeriesDetailsClient

    @ObservableState
    public struct State {
        var id: Int
        public let transitionID: String?
        var tvSeries: TVSeries?
        var isReady: Bool {
            tvSeries != nil
        }

        public init(
            id: Int,
            transitionID: String? = nil,
            tvSeries: TVSeries? = nil
        ) {
            self.id = id
            self.transitionID = transitionID
            self.tvSeries = tvSeries
        }
    }

    public enum Action {
        case load
        case tvSeriesLoaded(TVSeries)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                return handleFetchTVSeries(&state)

            case .tvSeriesLoaded(let tvSeries):
                state.tvSeries = tvSeries
                return .none
            }
        }
    }

}

extension TVSeriesDetailsFeature {

    fileprivate func handleFetchTVSeries(_ state: inout State) -> EffectOf<Self> {
        let id = state.id

        return .run { send in
            do {
                let tvSeries = try await tvSeriesDetails.fetch(id)
                await send(.tvSeriesLoaded(tvSeries))
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
