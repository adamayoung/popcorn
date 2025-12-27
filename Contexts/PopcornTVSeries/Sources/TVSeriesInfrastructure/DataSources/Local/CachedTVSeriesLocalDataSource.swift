//
//  CachedTVSeriesLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Caching
import Foundation
import TVSeriesDomain

actor CachedTVSeriesLocalDataSource: TVSeriesLocalDataSource {

    private let cache: any Caching

    init(cache: some Caching) {
        self.cache = cache
    }

    func tvSeries(withID id: Int) async -> TVSeries? {
        await cache.item(forKey: .tvSeries(id: id), ofType: TVSeries.self)
    }

    func setTVSeries(_ tvSeries: TVSeries) async {
        await cache.setItem(tvSeries, forKey: .tvSeries(id: tvSeries.id))
    }

    func images(forTVSeries tvSeriesID: Int) async -> ImageCollection? {
        await cache.item(
            forKey: .images(tvSeriesID: tvSeriesID),
            ofType: ImageCollection.self
        )
    }

    func setImages(_ imageCollection: ImageCollection, forTVSeries tvSeriesID: Int) async {
        await cache.setItem(imageCollection, forKey: .images(tvSeriesID: tvSeriesID))
    }

}

extension CacheKey {

    static func tvSeries(id: Int) -> CacheKey {
        CacheKey("TVKit.TVInfrastructure.tv-series-\(id)")
    }

    static func images(tvSeriesID: Int) -> CacheKey {
        CacheKey("TVKit.TVInfrastructure.tv-series-\(tvSeriesID)-images")
    }

}
