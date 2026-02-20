//
//  FeatureFlag.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

enum FeatureFlag: String {

    // MARK: - Navigation

    case explore
    case mediaSearch = "media_search"

    // MARK: - Explore Screen

    case exploreDiscoverMovies = "explore_discover_movies"
    case exploreTrendingMovies = "explore_trending_movies"
    case explorePopularMovies = "explore_popular_movies"
    case exploreTrendingTVSeries = "explore_trending_tv_series"
    case exploreTrendingPeople = "explore_trending_people"

    // MARK: - Games

    case games
    case plotRemixGame = "plot_remix_game"
    case emojiPlotDecoderGame = "emoji_plot_decoder_game"
    case posterPixelationGame = "poster_pixelation_game"
    case timelineTangleGame = "timeline_tangle_game"

    // MARK: - Intelligence

    case movieIntelligence = "movie_intelligence"
    case tvSeriesIntelligence = "tv_series_intelligence"

    // MARK: - App Wide

    case watchlist

    // MARK: - Movie Details

    case movieDetailsCastAndCrew = "movie_details_cast_and_crew"
    case movieDetailsRecommendedMovies = "movie_details_recommended_movies"

    // MARK: - Artwork

    case backdropFocalPoint = "backdrop_focal_point"

}
