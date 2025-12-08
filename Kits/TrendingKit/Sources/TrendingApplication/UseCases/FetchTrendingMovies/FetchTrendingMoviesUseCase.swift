//
//  FetchTrendingMoviesUseCase.swift
//  TrendingKit
//
//  Created by Adam Young on 03/06/2025.
//

import Foundation

public protocol FetchTrendingMoviesUseCase: Sendable {

    func execute() async throws(FetchTrendingMoviesError) -> [MoviePreviewDetails]

    func execute(page: Int) async throws(FetchTrendingMoviesError) -> [MoviePreviewDetails]

}
