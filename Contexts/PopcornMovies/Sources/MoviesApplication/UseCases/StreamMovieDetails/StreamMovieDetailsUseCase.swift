//
//  StreamMovieDetailsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A use case that streams real-time updates of movie details.
///
/// This protocol defines the contract for observing changes to movie details over time.
/// The stream emits updates whenever the underlying data changes, such as when cached
/// data is updated or when background synchronization occurs.
///
public protocol StreamMovieDetailsUseCase: Sendable {

    ///
    /// Creates a stream that emits movie details updates for a specific movie.
    ///
    /// The stream will immediately emit the current cached data (if available),
    /// then continue emitting updates as the data changes.
    ///
    /// - Parameter id: The unique identifier of the movie to observe.
    /// - Returns: An async throwing stream that emits ``MovieDetails`` or `nil` if not available.
    ///
    func stream(id: Int) async -> AsyncThrowingStream<MovieDetails?, Error>

}
