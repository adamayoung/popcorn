//
//  TrendingTVSeriesView.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The trending TV series view, driven by ``TrendingTVSeriesViewModel``.
///
/// Renders a `List` of ``TVSeriesRow`` items via `NavigationRow`.
public struct TrendingTVSeriesView: View {

    @State private var viewModel: TrendingTVSeriesViewModel

    public init(viewModel: TrendingTVSeriesViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        List(viewModel.tvSeries) { tvSeries in
            NavigationRow {
                viewModel.selectTVSeries(id: tvSeries.id)
            } content: {
                TVSeriesRow(
                    id: tvSeries.id,
                    name: tvSeries.name,
                    posterURL: tvSeries.posterURL
                )
            }
        }
        .navigationTitle(Text("TRENDING", bundle: .module))
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

#if DEBUG
    #Preview {
        NavigationStack {
            TrendingTVSeriesView(viewModel: .preview())
        }
    }
#endif
