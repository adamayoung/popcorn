//
//  StreamMovieDetailsUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol StreamMovieDetailsUseCase: Sendable {

    func stream(id: Int) async -> AsyncThrowingStream<MovieDetails?, Error>

}
