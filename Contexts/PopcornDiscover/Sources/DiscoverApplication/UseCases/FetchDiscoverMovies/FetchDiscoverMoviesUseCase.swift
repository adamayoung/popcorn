//
//  FetchDiscoverMoviesUseCase.swift
//  PopcornDiscover
//
//  Created by Adam Young on 08/12/2025.
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
