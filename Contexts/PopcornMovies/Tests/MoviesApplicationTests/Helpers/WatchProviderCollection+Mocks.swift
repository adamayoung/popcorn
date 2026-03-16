//
//  WatchProviderCollection+Mocks.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

extension WatchProvider {

    static func mock(
        id: Int = 1,
        name: String = "Test Provider",
        logoPath: URL? = nil
    ) -> WatchProvider {
        WatchProvider(
            id: id,
            name: name,
            logoPath: logoPath
        )
    }

}

extension WatchProviderCollection {

    static func mock(
        id: Int = 1,
        // swiftlint:disable:next force_unwrapping
        link: URL = URL(string: "https://www.themoviedb.org/movie/1/watch")!,
        streamingProviders: [WatchProvider] = [.mock()],
        buyProviders: [WatchProvider] = [],
        rentProviders: [WatchProvider] = [],
        freeProviders: [WatchProvider] = []
    ) -> WatchProviderCollection {
        WatchProviderCollection(
            id: id,
            link: link,
            streamingProviders: streamingProviders,
            buyProviders: buyProviders,
            rentProviders: rentProviders,
            freeProviders: freeProviders
        )
    }

}
