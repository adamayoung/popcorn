//
//  FetchDiscoverMoviesUseCase.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

public protocol FetchDiscoverMoviesUseCase: Sendable {

    func execute() async throws(FetchDiscoverMoviesError) -> MoviePreviewDetailsPage

    func execute(filter: MovieFilter) async throws(FetchDiscoverMoviesError)
        -> MoviePreviewDetailsPage

    func execute(page: Int) async throws(FetchDiscoverMoviesError) -> MoviePreviewDetailsPage

    func execute(filter: MovieFilter?, page: Int) async throws(FetchDiscoverMoviesError)
        -> MoviePreviewDetailsPage

}
