//
//  StreamMovieDetailsUseCase.swift
//  PopcornMovies
//
//  Created by Adam Young on 02/12/2025.
//

import Foundation

public protocol StreamMovieDetailsUseCase: Sendable {

    func stream(id: Int) async -> AsyncThrowingStream<MovieDetails?, Error>

}
