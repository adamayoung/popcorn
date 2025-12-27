//
//  InMemoryCache.swift
//  Caching
//
//  Copyright © 2025 Adam Young.
//

import Foundation
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
        guard let cacheItem = cache[key] else {
            Self.logger.debug("CACHE MISS: \(key.rawValue, privacy: .public)")
            return nil
        }

        if cacheItem.isExpired {
            await removeItem(forKey: key)
            Self.logger.debug("CACHE EXPIRED: \(key.rawValue, privacy: .public)")
            return nil
        }

        Self.logger.debug("CACHE HIT: \(key.rawValue, privacy: .public)")

        return cacheItem.value as? Item
    }

    func setItem(_ item: some Any, forKey key: CacheKey) async {
        await setItem(item, forKey: key, expiresIn: defaultExpiresIn)
    }

    func setItem(_ item: some Any, forKey key: CacheKey, expiresIn: TimeInterval) async {
        Self.logger.debug("CACHE SET: \(key.rawValue, privacy: .public)")
        cache[key] = CacheItem(value: item, expiresIn: expiresIn)
    }

    func removeItem(forKey key: CacheKey) async {
        Self.logger.debug("CACHE REMOVE: \(key.rawValue, privacy: .public)")
        cache.removeValue(forKey: key)
    }

    func flush() async {
        Self.logger.debug("CACHE FLUSH")
        cache = [:]
    }

}
