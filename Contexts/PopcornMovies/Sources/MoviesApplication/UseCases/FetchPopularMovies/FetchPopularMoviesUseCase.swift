//
//  FetchPopularMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FetchPopularMoviesUseCase: Sendable {

    func execute() async throws(FetchPopularMoviesError) -> [MoviePreviewDetails]

    func execute(page: Int) async throws(FetchPopularMoviesError) -> [MoviePreviewDetails]

}
