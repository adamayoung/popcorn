//
//  StubMovieLogoImageProvider.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

public final class StubMovieLogoImageProvider: MovieLogoImageProviding, Sendable {

    public init() {}

    public func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError) -> ImageURLSet? {
        nil
    }

}
