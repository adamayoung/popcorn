//
//  FetchPopularMoviesUseCase.swift
//  PopcornMovies
//
//  Created by Adam Young on 21/11/2025.
//

import Foundation

public protocol FetchPopularMoviesUseCase: Sendable {

    func execute() async throws(FetchPopularMoviesError) -> [MoviePreviewDetails]

    func execute(page: Int) async throws(FetchPopularMoviesError) -> [MoviePreviewDetails]

}
