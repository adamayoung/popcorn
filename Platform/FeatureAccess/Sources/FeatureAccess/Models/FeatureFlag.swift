//
//  FeatureFlag.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

/// A feature flag that controls access to a specific feature in the app.
public struct FeatureFlag: Identifiable, Equatable, Sendable {

    /// The unique identifier for the feature flag.
    public let id: String

    /// A human-readable name for the feature flag.
    public let name: String

    /// A description of what the feature flag controls.
    public let description: String

}

public extension FeatureFlag {

    /// All available feature flags.
    static let allFlags: [FeatureFlag] = [
        .explore,
        .mediaSearch,
        .exploreDiscoverMovies,
        .exploreTrendingMovies,
        .explorePopularMovies,
        .exploreTrendingTVSeries,
        .exploreTrendingPeople,
        .games,
        .plotRemixGame,
        .emojiPlotDecoderGame,
        .posterPixelationGame,
        .timelineTangleGame,
        .movieIntelligence,
        .tvSeriesIntelligence,
        .watchlist,
        .backdropFocalPoint
    ]

}

public extension FeatureFlag {

    static func flag(withID id: String) -> FeatureFlag? {
        allFlags.first { $0.id == id }
    }

}

public extension FeatureFlag {

    // MARK: - Navigation

    /// Controls access to the Explore screen.
    static let explore = FeatureFlag(
        id: "explore",
        name: "Explore",
        description: "Access to the Explore screen"
    )

    /// Controls access to the Media Search screen.
    static let mediaSearch = FeatureFlag(
        id: "media_search",
        name: "Media Search",
        description: "Access to the Media Search screen"
    )

    // MARK: - Explore Screen

    /// Controls the Discover Movies section on the Explore screen.
    static let exploreDiscoverMovies = FeatureFlag(
        id: "explore_discover_movies",
        name: "Explore Discover Movies",
        description: "Show Discover Movies section on the Explore screen"
    )

    /// Controls the Trending Movies section on the Explore screen.
    static let exploreTrendingMovies = FeatureFlag(
        id: "explore_trending_movies",
        name: "Explore Trending Movies",
        description: "Show Trending Movies section on the Explore screen"
    )

    /// Controls the Popular Movies section on the Explore screen.
    static let explorePopularMovies = FeatureFlag(
        id: "explore_popular_movies",
        name: "Explore Popular Movies",
        description: "Show Popular Movies section on the Explore screen"
    )

    /// Controls the Trending TV Series section on the Explore screen.
    static let exploreTrendingTVSeries = FeatureFlag(
        id: "explore_trending_tv_series",
        name: "Explore Trending TV Series",
        description: "Show Trending TV Series section on the Explore screen"
    )

    /// Controls the Trending People section on the Explore screen.
    static let exploreTrendingPeople = FeatureFlag(
        id: "explore_trending_people",
        name: "Explore Trending People",
        description: "Show Trending People section on the Explore screen"
    )

    // MARK: - Games

    /// Controls access to the Games tab.
    static let games = FeatureFlag(
        id: "games",
        name: "Games",
        description: "Access to the Games tab"
    )

    /// Controls access to the Plot Remix game.
    static let plotRemixGame = FeatureFlag(
        id: "plot_remix_game",
        name: "Plot Remix Game",
        description: "Access to the Plot Remix game"
    )

    /// Controls access to the Emoji Plot Decoder game.
    static let emojiPlotDecoderGame = FeatureFlag(
        id: "emoji_plot_decoder_game",
        name: "Emoji Plot Decoder Game",
        description: "Access to the Emoji Plot Decoder game"
    )

    /// Controls access to the Poster Pixelation game.
    static let posterPixelationGame = FeatureFlag(
        id: "poster_pixelation_game",
        name: "Poster Pixelation Game",
        description: "Access to the Poster Pixelation game"
    )

    /// Controls access to the Timeline Tangle game.
    static let timelineTangleGame = FeatureFlag(
        id: "timeline_tangle_game",
        name: "Timeline Tangle Game",
        description: "Access to the Timeline Tangle game"
    )

    // MARK: - Intelligence

    /// Controls access to AI-powered movie chat.
    static let movieIntelligence = FeatureFlag(
        id: "movie_intelligence",
        name: "Movie Intelligence",
        description: "Access to AI-powered movie chat"
    )

    /// Controls access to AI-powered TV series chat.
    static let tvSeriesIntelligence = FeatureFlag(
        id: "tv_series_intelligence",
        name: "TV Series Intelligence",
        description: "Access to AI-powered TV series chat"
    )

    // MARK: - App Wide

    /// Controls access to the Watchlist feature.
    static let watchlist = FeatureFlag(
        id: "watchlist",
        name: "Watchlist",
        description: "Access to the Watchlist feature"
    )

    // MARK: - Artwork

    /// Controls focal point positioning for backdrop artwork.
    static let backdropFocalPoint = FeatureFlag(
        id: "backdrop_focal_point",
        name: "Backdrop Focal Point",
        description: "Enable focal point for backdrop artwork"
    )

}
