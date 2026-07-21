//
//  TMDbTrendingRemoteDataSource.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
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

    func movies(page: Int) async throws(TrendingRepositoryError) -> MoviePreviewPage {
        let response: MoviePageableList
        do {
            response = try await trendingService.movies(
                inTimeWindow: .day,
                page: page,
                language: nil
            )
        } catch let error {
            throw TrendingRepositoryError(error)
        }

        let mapper = MoviePreviewMapper()
        return MoviePreviewPage(
            page: response.page,
            // TMDb's `TrendingService` preconditions `page` to 1...1000; clamping
            // `totalPages` here guarantees no caller ever requests beyond that limit.
            totalPages: min(response.totalPages, 1000),
            movies: response.results.map(mapper.map)
        )
    }

    func tvSeries(
        page: Int
    ) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        let tmdbTVSeries: [TVSeriesListItem]
        do {
            tmdbTVSeries = try await trendingService.tvSeries(
                inTimeWindow: .day,
                page: page,
                language: nil
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
                language: nil
            ).results
        } catch let error {
            throw TrendingRepositoryError(error)
        }

        let mapper = PersonPreviewMapper()
        return tmdbPeople.map(mapper.map)
    }

}

private extension TrendingRepositoryError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    init(_ error: TMDbError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
