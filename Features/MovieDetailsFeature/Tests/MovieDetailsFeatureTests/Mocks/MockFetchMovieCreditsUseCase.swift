//
//  MockFetchMovieCreditsUseCase.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesApplication

struct MockFetchMovieCreditsUseCase: FetchMovieCreditsUseCase {

    let credits: MoviesApplication.CreditsDetails?

    func execute(movieID: Int) async throws(FetchMovieCreditsError) -> MoviesApplication.CreditsDetails {
        guard let credits else {
            throw .notFound
        }
        return credits
    }

}
