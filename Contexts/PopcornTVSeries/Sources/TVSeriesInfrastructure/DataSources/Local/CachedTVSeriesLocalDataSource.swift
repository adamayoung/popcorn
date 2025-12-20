//
//  CachedTVSeriesLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Caching
import Foundation
import Observability
import TVSeriesDomain

actor CachedTVSeriesLocalDataSource: TVSeriesLocalDataSource {

    private let cache: any Caching

    init(cache: some Caching) {
        self.cache = cache
    }

    func tvSeries(withID id: Int) async -> TVSeries? {
        let span = SpanContext.startChild(
            operation: .localDataSourceGet,
            description: "Get TV Series #\(id)"
        )
        span?.setData([
            "entity_type": "TVSeries",
            "entity_id": id
        ])

        let result = await cache.item(forKey: .tvSeries(id: id), ofType: TVSeries.self)

        span?.finish()
        return result
    }

    func setTVSeries(_ tvSeries: TVSeries) async {
        let span = SpanContext.startChild(
            operation: .localDataSourceSet,
            description: "Set TV Series #\(tvSeries.id)"
        )
        span?.setData([
            "entity_type": "TVSeries",
            "entity_id": tvSeries.id
        ])

        await cache.setItem(tvSeries, forKey: .tvSeries(id: tvSeries.id))

        span?.finish()
    }

    func images(forTVSeries tvSeriesID: Int) async -> ImageCollection? {
        let span = SpanContext.startChild(
            operation: .localDataSourceGet,
            description: "Get TV Series Image Collection #\(tvSeriesID)"
        )
        span?.setData([
            "entity_type": "imageCollection",
            "entity_id": tvSeriesID
        ])

        let result = await cache.item(
            forKey: .images(tvSeriesID: tvSeriesID),
            ofType: ImageCollection.self
        )

        span?.finish()
        return result
    }

    func setImages(_ imageCollection: ImageCollection, forTVSeries tvSeriesID: Int) async {
        let span = SpanContext.startChild(
            operation: .localDataSourceSet,
            description: "Set TV Series Image Collection #\(tvSeriesID)"
        )
        span?.setData([
            "entity_type": "imageCollection",
            "entity_id": tvSeriesID
        ])

        await cache.setItem(imageCollection, forKey: .images(tvSeriesID: tvSeriesID))

        span?.finish()
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
