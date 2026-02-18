//
//  StreamWatchlistMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol StreamWatchlistMoviesUseCase: Sendable {

    func stream() async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

}
