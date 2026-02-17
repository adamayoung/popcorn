//
//  CachedGenreLocalDataSource.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Caching
import Foundation
import GenresDomain

actor CachedGenreLocalDataSource: GenreLocalDataSource {

    private let cache: any Caching

    init(cache: some Caching) {
        self.cache = cache
    }

    func movieGenres() async throws(GenreLocalDataSourceError) -> [Genre]? {
        await cache.item(forKey: .movieGenres, ofType: [Genre].self)
    }

    func setMovieGenres(_ genres: [Genre]) async throws(GenreLocalDataSourceError) {
        await cache.setItem(genres, forKey: .movieGenres)
    }

    func tvSeriesGenres() async throws(GenreLocalDataSourceError) -> [Genre]? {
        await cache.item(forKey: .tvSeriesGenres, ofType: [Genre].self)
    }

    func setTVSeriesGenres(_ genres: [Genre]) async throws(GenreLocalDataSourceError) {
        await cache.setItem(genres, forKey: .tvSeriesGenres)
    }

}

extension CacheKey {

    static let movieGenres = CacheKey("PopcornGenres.GenresInfrastructure.movie-genres")
    static let tvSeriesGenres = CacheKey("PopcornGenres.GenresInfrastructure.tv-series-genres")

}
