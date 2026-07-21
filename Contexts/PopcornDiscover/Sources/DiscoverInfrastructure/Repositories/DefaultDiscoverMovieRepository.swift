//
//  DefaultDiscoverMovieRepository.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation

final class DefaultDiscoverMovieRepository: DiscoverMovieRepository {

    private let remoteDataSource: any DiscoverRemoteDataSource
    private let localDataSource: any DiscoverMovieLocalDataSource

    init(
        remoteDataSource: some DiscoverRemoteDataSource,
        localDataSource: any DiscoverMovieLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieRepositoryError) -> MoviePreviewPage {
        do {
            if let cachedPage = try await localDataSource.movies(filter: filter, page: page) {
                return cachedPage
            }
        } catch let error {
            throw DiscoverMovieRepositoryError(error)
        }

        let moviePage: MoviePreviewPage
        do {
            moviePage = try await remoteDataSource.movies(filter: filter, page: page)
        } catch let error {
            throw DiscoverMovieRepositoryError(error)
        }

        try? await localDataSource.setMovies(moviePage, filter: filter)

        return moviePage
    }

}

extension DiscoverMovieRepositoryError {

    init(_ error: DiscoverMovieLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: DiscoverRemoteDataSourceError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
