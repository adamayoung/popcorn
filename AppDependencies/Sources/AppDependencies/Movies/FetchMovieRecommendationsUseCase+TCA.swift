//
//  FetchMovieRecommendationsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchMovieRecommendationsUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieRecommendationsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchMovieRecommendationsUseCase()
    }

    static var testValue: any FetchMovieRecommendationsUseCase {
        UnimplementedFetchMovieRecommendationsUseCase()
    }

}

public extension DependencyValues {

    var fetchMovieRecommendations: any FetchMovieRecommendationsUseCase {
        get { self[FetchMovieRecommendationsUseCaseKey.self] }
        set { self[FetchMovieRecommendationsUseCaseKey.self] = newValue }
    }

}

private struct UnimplementedFetchMovieRecommendationsUseCase: FetchMovieRecommendationsUseCase {

    func execute(
        movieID: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        fatalError("FetchMovieRecommendationsUseCase.execute(movieID:) is unimplemented")
    }

    func execute(
        movieID: Int,
        page: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        fatalError("FetchMovieRecommendationsUseCase.execute(movieID:page:) is unimplemented")
    }

}
