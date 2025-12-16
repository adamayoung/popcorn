//
//  FeatureFlag.swift
//  FeatureFlags
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public enum FeatureFlag: String, Sendable, CaseIterable {
    // Navigation
    case explore = "explore"
    case mediaSearch = "media_search"

    // Explore Screen
    case exploreDiscoverMovies = "explore_discover_movies"
    case exploreTrendingMovies = "explore_trending_movies"
    case explorePopularMovies = "explore_popular_movies"
    case exploreTrendingTVSeries = "explore_trending_tv_series"
    case exploreTrendingPeople = "explore_trending_people"

    // Games
    case games = "games"
    case plotRemixGame = "plot_remix_game"
    case emojiPlotDecoderGame = "emoji_plot_decoder_game"
    case posterPixelationGame = "poster_pixelation_game"
    case timelineTangleGame = "timeline_tangle_game"

    // App Wide
    case watchlist = "watchlist"
}
