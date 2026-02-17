//
//  FetchTrendingMoviesUseCase.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FetchTrendingMoviesUseCase: Sendable {

    func execute() async throws(FetchTrendingMoviesError) -> [MoviePreviewDetails]

    func execute(page: Int) async throws(FetchTrendingMoviesError) -> [MoviePreviewDetails]

}
