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
/// A standalone leaf view that owns its view model. Renders an adaptive grid of
/// movie posters — three across on iPhone, more on wider screens. Takes a
/// `transitionNamespace` even though it does not apply `.matchedTransitionSource`
/// (no zoom transition).
public struct TrendingMoviesView: View {

    /// A 100pt minimum keeps three posters across on every iPhone width
    /// (375–440pt) while letting iPad and Mac fit more.
    private static let columns = [
        GridItem(.adaptive(minimum: 100), spacing: .spacing16)
    ]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
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
        ScrollView {
            content
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

extension TrendingMoviesView {

    private var content: some View {
        LazyVGrid(columns: Self.columns, spacing: .spacing16) {
            ForEach(movies.enumerated(), id: \.element.id) { offset, movie in
                Button {
                    viewModel.selectMovie(id: movie.id)
                } label: {
                    PosterImage(url: movie.posterURL)
                        .aspectRatio(500.0 / 750.0, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        }
                }
                .accessibilityIdentifier("trendingMovies.movie.\(offset)")
                .accessibilityLabel(Text(verbatim: movie.title))
                .accessibilityHint(Text("VIEW_MOVIE_DETAILS_HINT", bundle: .module))
                .buttonStyle(.plain)
            }
        }
        .animation(reduceMotion ? nil : .default, value: movies)
        .padding()
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
