//
//  TrendingMoviesView.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The trending movies view, driven by ``TrendingMoviesViewModel``.
///
/// A standalone leaf view that owns its view model. Renders a list of trending
/// movies. Takes a `transitionNamespace` even though it does not apply
/// `.matchedTransitionSource` (no zoom transition).
public struct TrendingMoviesView: View {

    @State private var viewModel: TrendingMoviesViewModel
    private let namespace: Namespace.ID

    private var movies: [MoviePreview] {
        viewModel.movies
    }

    private var isLoading: Bool {
        viewModel.isInitiallyLoading
    }

    public init(
        viewModel: TrendingMoviesViewModel,
        transitionNamespace: Namespace.ID
    ) {
        _viewModel = State(initialValue: viewModel)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        List(movies) { movie in
            NavigationRow {
                viewModel.selectMovie(id: movie.id)
            } content: {
                MovieRow(
                    id: movie.id,
                    title: movie.title,
                    posterURL: movie.posterURL
                )
            }
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .navigationTitle(Text("TRENDING_MOVIES", bundle: .module))
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

#if DEBUG
    #Preview {
        @Previewable @Namespace var namespace

        NavigationStack {
            TrendingMoviesView(
                viewModel: .preview(),
                transitionNamespace: namespace
            )
        }
    }
#endif
