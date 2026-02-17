//
//  InMemoryCache.swift
//  Caching
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability
import OSLog

actor InMemoryCache: Caching {

    private static let logger = Logger.caching

    var count: Int {
        cache.count
    }

    var isEmpty: Bool {
        cache.isEmpty
    }

    private let defaultExpiresIn: TimeInterval
    private var cache: [CacheKey: CacheItem<Any>] = [:]

    init(defaultExpiresIn: TimeInterval = 60 * 60) {
        self.defaultExpiresIn = defaultExpiresIn
    }

    func item<Item>(forKey key: CacheKey, ofType type: Item.Type) async -> Item? {
        let span = SpanContext.startChild(
            operation: .cacheGet,
            description: "Get cache item"
        )
        span?.setData(key: "key", value: key.rawValue)

        guard let cacheItem = cache[key] else {
            Self.logger.debug("CACHE MISS: \(key.rawValue, privacy: .public)")
            span?.setData(key: "cache-result", value: "MISS")
            span?.finish()
            return nil
        }

        if cacheItem.isExpired {
            await removeItem(forKey: key)
            Self.logger.debug("CACHE EXPIRED: \(key.rawValue, privacy: .public)")
            span?.setData(key: "cache-result", value: "EXPIRED")
            span?.finish()
            return nil
        }

        Self.logger.debug("CACHE HIT: \(key.rawValue, privacy: .public)")
        span?.setData(key: "cache-result", value: "HIT")
        span?.finish()

        return cacheItem.value as? Item
    }

    func setItem(_ item: some Any, forKey key: CacheKey) async {
        await setItem(item, forKey: key, expiresIn: defaultExpiresIn)
    }

    func setItem(_ item: some Any, forKey key: CacheKey, expiresIn: TimeInterval) async {
        let span = SpanContext.startChild(
            operation: .cacheSet,
            description: "Set cache item"
        )
        span?.setData(key: "key", value: key.rawValue)
        span?.setData(key: "expires-in", value: expiresIn)

        Self.logger.debug("CACHE SET: \(key.rawValue, privacy: .public)")
        cache[key] = CacheItem(value: item, expiresIn: expiresIn)
        span?.finish()
    }

    func removeItem(forKey key: CacheKey) async {
        let span = SpanContext.startChild(
            operation: .cacheRemove,
            description: "Remove item from cache"
        )
        span?.setData(key: "key", value: key.rawValue)

        Self.logger.debug("CACHE REMOVE: \(key.rawValue, privacy: .public)")
        cache.removeValue(forKey: key)
        span?.finish()
    }

    func flush() async {
        let span = SpanContext.startChild(
            operation: .cacheFlush,
            description: "Flush cache"
        )

        Self.logger.debug("CACHE FLUSH")
        cache = [:]
        span?.finish()
    }

}
