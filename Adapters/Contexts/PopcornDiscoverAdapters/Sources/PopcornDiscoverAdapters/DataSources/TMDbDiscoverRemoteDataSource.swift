//
//  TMDbDiscoverRemoteDataSource.swift
//  PopcornDiscoverAdapters
//
//  Created by Adam Young on 29/05/2025.
//

import DiscoverDomain
import DiscoverInfrastructure
import Foundation
import TMDb

final class TMDbDiscoverRemoteDataSource: DiscoverRemoteDataSource {

    private let discoverService: any DiscoverService

    init(discoverService: some DiscoverService) {
        self.discoverService = discoverService
    }

    func movies(page: Int) async throws(DiscoverRemoteDataSourceError) -> [MoviePreview] {
        try await movies(filter: nil, page: page)
    }

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [MoviePreview] {
        let filterMapper = TMDbDiscoverMovieFilterMapper()
        let tmdbMovies: [MovieListItem]
        do {
            tmdbMovies = try await discoverService.movies(
                filter: filterMapper.compactMap(filter),
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw DiscoverRemoteDataSourceError(error)
        }

        let mapper = MoviePreviewMapper()
        return tmdbMovies.map(mapper.map)
    }

    func tvSeries(page: Int) async throws(DiscoverRemoteDataSourceError) -> [TVSeriesPreview] {
        try await tvSeries(filter: nil, page: page)
    }

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [TVSeriesPreview] {
        let filterMapper = TMDbDiscoverTVSeriesFilterMapper()
        let tmdbTVSeries: [TVSeriesListItem]
        do {
            tmdbTVSeries = try await discoverService.tvSeries(
                filter: filterMapper.compactMap(filter),
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw DiscoverRemoteDataSourceError(error)
        }

        let mapper = TVSeriesPreviewMapper()
        return tmdbTVSeries.map(mapper.map)
    }

}

extension DiscoverRemoteDataSourceError {

    fileprivate init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    fileprivate init(_ error: TMDbError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
