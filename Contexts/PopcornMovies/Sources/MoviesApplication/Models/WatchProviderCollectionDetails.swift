//
//  WatchProviderCollectionDetails.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct WatchProviderCollectionDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let link: String
    public let streamingProviders: [WatchProviderDetails]
    public let buyProviders: [WatchProviderDetails]
    public let rentProviders: [WatchProviderDetails]
    public let freeProviders: [WatchProviderDetails]

    public init(
        id: Int,
        link: String,
        streamingProviders: [WatchProviderDetails] = [],
        buyProviders: [WatchProviderDetails] = [],
        rentProviders: [WatchProviderDetails] = [],
        freeProviders: [WatchProviderDetails] = []
    ) {
        self.id = id
        self.link = link
        self.streamingProviders = streamingProviders
        self.buyProviders = buyProviders
        self.rentProviders = rentProviders
        self.freeProviders = freeProviders
    }

}
