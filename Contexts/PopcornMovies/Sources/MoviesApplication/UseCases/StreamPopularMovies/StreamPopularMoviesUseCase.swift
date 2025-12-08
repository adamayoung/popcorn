//
//  StreamPopularMoviesUseCase.swift
//  PopcornMovies
//
//  Created by Adam Young on 02/12/2025.
//

import Foundation
import MoviesDomain

public protocol StreamPopularMoviesUseCase: Sendable {

    func stream() async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

    func loadNextPage() async throws(StreamPopularMoviesError)

    func refresh() async throws(StreamPopularMoviesError)

}
