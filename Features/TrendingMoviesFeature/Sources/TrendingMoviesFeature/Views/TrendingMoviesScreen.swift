//
//  TrendingMoviesScreen.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The MVVM trending movies screen, driven by ``TrendingMoviesViewModel``.
///
/// A standalone leaf screen that owns its view model. Renders the same store-free
/// list as the former `TrendingMoviesView`. Takes a `transitionNamespace` to match
/// the old view's signature even though, like the old view, it does not apply
/// `.matchedTransitionSource` (no zoom transition).
public struct TrendingMoviesScreen: View {

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
        .navigationTitle(Text("TRENDING", bundle: .module))
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

#if DEBUG
    #Preview {
        @Previewable @Namespace var namespace

        NavigationStack {
            TrendingMoviesScreen(
                viewModel: .preview(),
                transitionNamespace: namespace
            )
        }
    }
#endif
