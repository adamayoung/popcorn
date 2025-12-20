//
//  StreamPopularMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public protocol StreamPopularMoviesUseCase: Sendable {

    func stream() async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

    func loadNextPage() async throws(StreamPopularMoviesError)

    func refresh() async throws(StreamPopularMoviesError)

}
