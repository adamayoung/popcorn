//
//  StubMovieLogoImageProvider.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

final class StubMovieLogoImageProvider: MovieLogoImageProviding, Sendable {

    func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError) -> ImageURLSet? {
        nil
    }

}
