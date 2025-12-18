//
//  InMemoryCache.swift
//  Caching
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation
import OSLog
import Observability

actor InMemoryCache: Caching {

    private static let logger = Logger(
        subsystem: "Caching",
        category: "InMemoryCache"
    )

    var count: Int {
        cache.count
    }

    var isEmpty: Bool {
        cache.isEmpty
    }

    private let defaultExpiresIn: TimeInterval?
    private var cache: [CacheKey: CacheItem<Any>] = [:]

    init(defaultExpiresIn: TimeInterval? = nil) {
        self.defaultExpiresIn = defaultExpiresIn
    }

    func item<Item>(forKey key: CacheKey, ofType type: Item.Type) async -> Item? {
        let span = SpanContext.startChild(
            operation: .cacheGet,
            description: "Get cache item"
        )
        span?.setData(key: "key", value: key.rawValue)

        guard let cacheItem = cache[key] else {
            Self.logger.trace("CACHE MISS: \(key.rawValue)")
            span?.setData(key: "cache-result", value: "MISS")
            span?.finish()
            return nil
        }

        if cacheItem.isExpired {
            await removeItem(forKey: key)
            Self.logger.trace("CACHE EXPIRED: \(key.rawValue)")
            span?.setData(key: "cache-result", value: "EXPIRED")
            span?.finish()
            return nil
        }

        Self.logger.trace("CACHE HIT: \(key.rawValue)")
        span?.setData(key: "cache-result", value: "HIT")
        span?.finish()

        return cacheItem.value as? Item
    }

    func setItem<Item>(_ item: Item, forKey key: CacheKey) async {
        await setItem(item, forKey: key, expiresIn: nil)
    }

    func setItem<Item>(_ item: Item, forKey key: CacheKey, expiresIn: TimeInterval?) async {
        let span = SpanContext.startChild(
            operation: .cacheSet,
            description: "Set cache item"
        )
        span?.setData(key: "key", value: key.rawValue)
        if let expiresIn {
            span?.setData(key: "expires-in", value: expiresIn)
        }

        Self.logger.trace("CACHE SET: \(key.rawValue)")
        cache[key] = CacheItem(value: item, expiresIn: expiresIn)
        span?.finish()
    }

    func removeItem(forKey key: CacheKey) async {
        let span = SpanContext.startChild(
            operation: .cacheRemove,
            description: "Remove item from cache"
        )
        span?.setData(key: "key", value: key.rawValue)

        Self.logger.trace("CACHE REMOVE: \(key.rawValue)")
        cache.removeValue(forKey: key)
        span?.finish()
    }

    func flush() async {
        let span = SpanContext.startChild(
            operation: .cacheFlush,
            description: "Flush cache"
        )

        Self.logger.trace("CACHE FLUSH")
        cache = [:]
        span?.finish()
    }

}
