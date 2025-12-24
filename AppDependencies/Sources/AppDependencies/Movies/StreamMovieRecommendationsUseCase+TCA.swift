//
//  StreamMovieRecommendationsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamMovieRecommendationsUseCaseKey: DependencyKey {

    static var liveValue: any StreamMovieRecommendationsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeStreamMovieRecommendationsUseCase()
    }

    static var testValue: any StreamMovieRecommendationsUseCase {
        UnimplementedStreamMovieRecommendationsUseCase()
    }

}

public extension DependencyValues {

    var streamMovieRecommendations: any StreamMovieRecommendationsUseCase {
        get { self[StreamMovieRecommendationsUseCaseKey.self] }
        set { self[StreamMovieRecommendationsUseCaseKey.self] = newValue }
    }

}

private struct UnimplementedStreamMovieRecommendationsUseCase: StreamMovieRecommendationsUseCase {

    func stream(movieID: Int) async -> AsyncThrowingStream<[MoviePreviewDetails], Error> {
        fatalError("StreamMovieRecommendationsUseCase.stream(movieID:) is unimplemented")
    }

    func stream(
        movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreviewDetails], Error> {
        fatalError("StreamMovieRecommendationsUseCase.stream(movieID:limit:) is unimplemented")
    }

    func loadNextPage(movieID: Int) async throws(StreamMovieRecommendationsError) {
        fatalError("StreamMovieRecommendationsUseCase.loadNextPage(movieID:) is unimplemented")
    }

}
