//
//  TrendingTVSeriesView.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct TrendingTVSeriesView: View {

    @Bindable var store: StoreOf<TrendingTVSeriesFeature>

    public init(store: StoreOf<TrendingTVSeriesFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        List(store.tvSeries) { tvSeries in
            NavigationRow {
                store.send(.navigate(.tvSeriesDetails(id: tvSeries.id)))
            } content: {
                TVSeriesRow(
                    id: tvSeries.id,
                    name: tvSeries.name,
                    posterURL: tvSeries.posterURL
                )
            }
        }
        .navigationTitle("Trending")
        .task {
            store.send(.loadTrendingTVSeries)
        }
    }

}

#Preview {
    TrendingTVSeriesView(
        store: Store(
            initialState: TrendingTVSeriesFeature.State(),
            reducer: {
                TrendingTVSeriesFeature()
            }
        )
    )
}
