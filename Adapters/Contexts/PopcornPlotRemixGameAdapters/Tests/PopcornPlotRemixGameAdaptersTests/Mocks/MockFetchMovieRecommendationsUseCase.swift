//
//  MockFetchMovieRecommendationsUseCase.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesApplication
import MoviesDomain

final class MockFetchMovieRecommendationsUseCase: FetchMovieRecommendationsUseCase, @unchecked Sendable {

    struct ExecuteCall: Equatable {
        let movieID: Int
    }

    struct ExecuteWithPageCall: Equatable {
        let movieID: Int
        let page: Int
    }

    var executeCallCount = 0
    var executeCalledWith: [ExecuteCall] = []
    var executeStub: Result<[MoviePreviewDetails], FetchMovieRecommendationsError>?

    var executeWithPageCallCount = 0
    var executeWithPageCalledWith: [ExecuteWithPageCall] = []
    var executeWithPageStub: Result<[MoviePreviewDetails], FetchMovieRecommendationsError>?

    func execute(movieID: Movie.ID) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        executeCallCount += 1
        executeCalledWith.append(ExecuteCall(movieID: movieID))

        guard let stub = executeStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    func execute(
        movieID: Movie.ID,
        page: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        executeWithPageCallCount += 1
        executeWithPageCalledWith.append(ExecuteWithPageCall(movieID: movieID, page: page))

        guard let stub = executeWithPageStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

}
