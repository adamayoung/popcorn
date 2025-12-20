//
//  FetchDiscoverMoviesUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

public protocol FetchDiscoverMoviesUseCase: Sendable {

    func execute() async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails]

    func execute(filter: MovieFilter) async throws(FetchDiscoverMoviesError)
        -> [MoviePreviewDetails]

    func execute(page: Int) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails]

    func execute(filter: MovieFilter?, page: Int) async throws(FetchDiscoverMoviesError)
        -> [MoviePreviewDetails]

}
