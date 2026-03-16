//
//  WatchProviderCollection.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct WatchProviderCollection: Identifiable, Equatable, Sendable {

    public let id: Int
    public let link: String
    public let streamingProviders: [WatchProvider]
    public let buyProviders: [WatchProvider]
    public let rentProviders: [WatchProvider]
    public let freeProviders: [WatchProvider]

    public init(
        id: Int,
        link: String,
        streamingProviders: [WatchProvider] = [],
        buyProviders: [WatchProvider] = [],
        rentProviders: [WatchProvider] = [],
        freeProviders: [WatchProvider] = []
    ) {
        self.id = id
        self.link = link
        self.streamingProviders = streamingProviders
        self.buyProviders = buyProviders
        self.rentProviders = rentProviders
        self.freeProviders = freeProviders
    }

}
