//
//  InMemoryCache.swift
//  Caching
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation
import OSLog

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
        guard let cacheItem = cache[key] else {
            Self.logger.trace("CACHE MISS: \(key.rawValue)")
            return nil
        }

        if cacheItem.isExpired {
            await removeItem(forKey: key)
            Self.logger.trace("CACHE MISS: \(key.rawValue)")
            return nil
        }

        Self.logger.trace("CACHE HIT: \(key.rawValue)")
        return cacheItem.value as? Item
    }

    func setItem<Item>(_ item: Item, forKey key: CacheKey) async {
        if let defaultExpiresIn {
            await setItem(item, forKey: key, expiresIn: defaultExpiresIn)
            return
        }

        Self.logger.trace("CACHE SET: \(key.rawValue)")
        cache[key] = CacheItem(value: item)
    }

    func setItem<Item>(_ item: Item, forKey key: CacheKey, expiresIn: TimeInterval) async {
        Self.logger.trace("CACHE SET: \(key.rawValue)")
        cache[key] = CacheItem(value: item, expiresIn: expiresIn)
    }

    func removeItem(forKey key: CacheKey) async {
        Self.logger.trace("CACHE REMOVE: \(key.rawValue)")
        cache.removeValue(forKey: key)
    }

    func flush() async {
        Self.logger.trace("CACHE FLUSH")
        cache = [:]
    }

}
