//
//  FeatureFlag.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Enumeration of all available feature flags in the application.
///
/// Feature flags control the visibility and availability of features across
/// different environments and user segments.
///
public enum FeatureFlag: String, Sendable, CaseIterable {
    // MARK: - Navigation

    /// Enables the explore navigation tab.
    case explore

    /// Enables the media search functionality.
    case mediaSearch = "media_search"

    // MARK: - Explore Screen

    /// Enables the discover movies section on the explore screen.
    case exploreDiscoverMovies = "explore_discover_movies"

    /// Enables the trending movies section on the explore screen.
    case exploreTrendingMovies = "explore_trending_movies"

    /// Enables the popular movies section on the explore screen.
    case explorePopularMovies = "explore_popular_movies"

    /// Enables the trending TV series section on the explore screen.
    case exploreTrendingTVSeries = "explore_trending_tv_series"

    /// Enables the trending people section on the explore screen.
    case exploreTrendingPeople = "explore_trending_people"

    // MARK: - Games

    /// Enables the games feature.
    case games

    /// Enables the Plot Remix game.
    case plotRemixGame = "plot_remix_game"

    /// Enables the Emoji Plot Decoder game.
    case emojiPlotDecoderGame = "emoji_plot_decoder_game"

    /// Enables the Poster Pixelation game.
    case posterPixelationGame = "poster_pixelation_game"

    /// Enables the Timeline Tangle game.
    case timelineTangleGame = "timeline_tangle_game"

    // MARK: - Intelligence

    /// Enables AI-powered movie intelligence features.
    case movieIntelligence = "movie_intelligence"

    /// Enables AI-powered TV series intelligence features.
    case tvSeriesIntelligence = "tv_series_intelligence"

    // MARK: - App Wide

    /// Enables the watchlist feature.
    case watchlist
}
