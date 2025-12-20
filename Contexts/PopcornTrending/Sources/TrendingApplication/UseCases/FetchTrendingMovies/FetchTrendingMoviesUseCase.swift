//
//  FetchTrendingMoviesUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol FetchTrendingMoviesUseCase: Sendable {

    func execute() async throws(FetchTrendingMoviesError) -> [MoviePreviewDetails]

    func execute(page: Int) async throws(FetchTrendingMoviesError) -> [MoviePreviewDetails]

}
