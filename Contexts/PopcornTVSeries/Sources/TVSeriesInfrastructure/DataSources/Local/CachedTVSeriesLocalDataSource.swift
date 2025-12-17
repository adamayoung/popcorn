//
//  CachedTVSeriesLocalDataSource.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 25/11/2025.
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
        await SpanContext.trace(
            operation: "cache.get",
            description: "Get TV Series #\(id)"
        ) { span in
            span?.setData([
                "entity_type": "tvSeries",
                "entity_id": id,
                "cache.key": "tvSeries:\(id)"
            ])
            return await cache.item(forKey: .tvSeries(id: id), ofType: TVSeries.self)
        }
    }

    func setTVSeries(_ tvSeries: TVSeries) async {
        await SpanContext.trace(
            operation: "cache.set",
            description: "Set TV Series #\(tvSeries.id)"
        ) { span in
            span?.setData([
                "entity_type": "tvSeries",
                "entity_id": tvSeries.id,
                "cache.key": "tvSeries:\(tvSeries.id)"
            ])
            await cache.setItem(tvSeries, forKey: .tvSeries(id: tvSeries.id))
        }
    }

    func images(forTVSeries tvSeriesID: Int) async -> ImageCollection? {
        await SpanContext.trace(
            operation: "cache.get",
            description: "Get TV Series Images #\(tvSeriesID)"
        ) { span in
            span?.setData([
                "entity_type": "imageCollection",
                "entity_id": tvSeriesID,
                "cache.key": "tvSeriesImages:\(tvSeriesID)"
            ])
            return await cache.item(
                forKey: .images(tvSeriesID: tvSeriesID),
                ofType: ImageCollection.self
            )
        }
    }

    func setImages(_ imageCollection: ImageCollection, forTVSeries tvSeriesID: Int) async {
        await SpanContext.trace(
            operation: "cache.set",
            description: "Set TV Series Images #\(tvSeriesID)"
        ) { span in
            span?.setData([
                "entity_type": "imageCollection",
                "entity_id": tvSeriesID,
                "cache.key": "tvSeriesImages:\(tvSeriesID)"
            ])
            await cache.setItem(imageCollection, forKey: .images(tvSeriesID: tvSeriesID))
        }
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
