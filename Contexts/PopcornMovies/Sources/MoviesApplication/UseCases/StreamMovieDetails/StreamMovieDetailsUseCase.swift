//
//  StreamMovieDetailsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol StreamMovieDetailsUseCase: Sendable {

    func stream(id: Int) async -> AsyncThrowingStream<MovieDetails?, Error>

}
