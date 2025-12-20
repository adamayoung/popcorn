//
//  GenresInfrastructureFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Caching
import Foundation
import GenresDomain

package final class GenresInfrastructureFactory {

    private static let cache: some Caching = CachesFactory.makeInMemoryCache(defaultExpiresIn: 60)

    private let genreRemoteDataSource: any GenreRemoteDataSource

    package init(genreRemoteDataSource: some GenreRemoteDataSource) {
        self.genreRemoteDataSource = genreRemoteDataSource
    }

    package func makeGenreRepository() -> some GenreRepository {
        let localDataSource = makeGenreLocalDataSource()

        return DefaultGenreRepository(
            remoteDataSource: genreRemoteDataSource,
            localDataSource: localDataSource
        )
    }

}

extension GenresInfrastructureFactory {

    private func makeGenreLocalDataSource() -> some GenreLocalDataSource {
        let cache = makeCache()
        return CachedGenreLocalDataSource(cache: cache)
    }

}

extension GenresInfrastructureFactory {

    private func makeCache() -> some Caching {
        Self.cache
    }

}
