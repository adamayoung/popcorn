//
//  TMDbTrendingRemoteDataSource.swift
//  PopcornTrendingAdapters
//
//  Created by Adam Young on 29/05/2025.
//

import Foundation
import TMDb
import TrendingDomain
import TrendingInfrastructure

final class TMDbTrendingRemoteDataSource: TrendingRemoteDataSource {

    private let trendingService: any TrendingService

    init(trendingService: some TrendingService) {
        self.trendingService = trendingService
    }

    func movies(page: Int) async throws(TrendingRepositoryError) -> [MoviePreview] {
        let tmdbMovies: [MovieListItem]
        do {
            tmdbMovies = try await trendingService.movies(
                inTimeWindow: .day,
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw TrendingRepositoryError(error)
        }

        let mapper = MoviePreviewMapper()
        return tmdbMovies.map(mapper.map)
    }

    func tvSeries(
        page: Int
    ) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        let tmdbTVSeries: [TVSeriesListItem]
        do {
            tmdbTVSeries = try await trendingService.tvSeries(
                inTimeWindow: .day,
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw TrendingRepositoryError(error)
        }

        let mapper = TVSeriesPreviewMapper()
        return tmdbTVSeries.map(mapper.map)
    }

    func people(
        page: Int
    ) async throws(TrendingRepositoryError) -> [PersonPreview] {
        let tmdbPeople: [PersonListItem]
        do {
            tmdbPeople = try await trendingService.people(
                inTimeWindow: .day,
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw TrendingRepositoryError(error)
        }

        let mapper = PersonPreviewMapper()
        return tmdbPeople.map(mapper.map)
    }

}

extension TrendingRepositoryError {

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
