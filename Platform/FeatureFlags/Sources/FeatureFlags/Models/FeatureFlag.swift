//
//  FeatureFlag.swift
//  FeatureFlags
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public enum FeatureFlag: String, Sendable {
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
    case emojiPlotDecoderGame = "emoji_plot_decoder_game"

    // App Wide
    case watchList = "watch_list"
}
