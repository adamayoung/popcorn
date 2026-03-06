//
//  DiskCache.swift
//  Caching
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability
import OSLog

actor DiskCache: Caching {

    private static let logger = Logger.caching

    var count: Int {
        cache.count
    }

    var isEmpty: Bool {
        cache.isEmpty
    }

    private let defaultExpiresIn: TimeInterval
    private let directoryURL: URL
    private var cache: [CacheKey: CacheItem<Any>] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(subdirectory: String, defaultExpiresIn: TimeInterval = 7 * 24 * 60 * 60) {
        self.defaultExpiresIn = defaultExpiresIn
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.directoryURL = cachesDirectory.appendingPathComponent(subdirectory, isDirectory: true)
        Self.createDirectoryIfNeeded(at: directoryURL)
    }

    func item<Item>(forKey key: CacheKey, ofType type: Item.Type) async -> Item? {
        let span = SpanContext.startChild(
            operation: .cacheGet,
            description: "Get disk cache item"
        )
        span?.setData(key: "key", value: key.rawValue)

        if let cacheItem = cache[key] {
            if cacheItem.isExpired {
                await removeItem(forKey: key)
                Self.logger.debug("DISK CACHE EXPIRED: \(key.rawValue, privacy: .public)")
                span?.setData(key: "cache-result", value: "EXPIRED")
                span?.finish()
                return nil
            }

            Self.logger.debug("DISK CACHE HIT (memory): \(key.rawValue, privacy: .public)")
            span?.setData(key: "cache-result", value: "HIT")
            span?.finish()
            return cacheItem.value as? Item
        }

        let result = readFromDisk(forKey: key, ofType: type)
        span?.setData(key: "cache-result", value: result.cacheResult)
        span?.finish()
        return result.item
    }

    private func readFromDisk<Item>(
        forKey key: CacheKey,
        ofType type: Item.Type
    ) -> (item: Item?, cacheResult: String) {
        let fileURL = fileURL(forKey: key)
        guard let data = try? Data(contentsOf: fileURL) else {
            Self.logger.debug("DISK CACHE MISS: \(key.rawValue, privacy: .public)")
            return (nil, "MISS")
        }

        guard let entry = try? decoder.decode(DiskCacheEntry.self, from: data) else {
            Self.logger.debug("DISK CACHE CORRUPT: \(key.rawValue, privacy: .public)")
            try? FileManager.default.removeItem(at: fileURL)
            return (nil, "CORRUPT")
        }

        if entry.isExpired {
            try? FileManager.default.removeItem(at: fileURL)
            Self.logger.debug("DISK CACHE EXPIRED (disk): \(key.rawValue, privacy: .public)")
            return (nil, "EXPIRED")
        }

        guard
            let decodableType = type as? any Decodable.Type,
            let item = try? decoder.decode(decodableType, from: entry.data) as? Item
        else {
            Self.logger.debug("DISK CACHE DECODE FAILED: \(key.rawValue, privacy: .public)")
            return (nil, "DECODE_FAILED")
        }

        let remainingInterval: TimeInterval? = {
            guard let expiresAt = entry.expiresAt else {
                return nil
            }
            return expiresAt.timeIntervalSinceNow
        }()
        cache[key] = CacheItem(value: item, expiresIn: remainingInterval)

        Self.logger.debug("DISK CACHE HIT (disk): \(key.rawValue, privacy: .public)")
        return (item, "HIT")
    }

    func setItem(_ item: some Any, forKey key: CacheKey) async {
        await setItem(item, forKey: key, expiresIn: defaultExpiresIn)
    }

    func setItem(_ item: some Any, forKey key: CacheKey, expiresIn: TimeInterval) async {
        let span = SpanContext.startChild(
            operation: .cacheSet,
            description: "Set disk cache item"
        )
        span?.setData(key: "key", value: key.rawValue)
        span?.setData(key: "expires-in", value: expiresIn)

        cache[key] = CacheItem(value: item, expiresIn: expiresIn)

        if let encodable = item as? any Encodable {
            do {
                let itemData = try encoder.encode(AnyEncodable(encodable))
                let expiresAt = Date().addingTimeInterval(expiresIn)
                let entry = DiskCacheEntry(expiresAt: expiresAt, data: itemData)
                let entryData = try encoder.encode(entry)
                try entryData.write(to: fileURL(forKey: key), options: .atomic)
                Self.logger.debug("DISK CACHE SET (memory + disk): \(key.rawValue, privacy: .public)")
            } catch {
                Self.logger.debug("DISK CACHE SET (memory only, encode failed): \(key.rawValue, privacy: .public)")
            }
        } else {
            Self.logger.debug("DISK CACHE SET (memory only, not Encodable): \(key.rawValue, privacy: .public)")
        }

        span?.finish()
    }

    func removeItem(forKey key: CacheKey) async {
        let span = SpanContext.startChild(
            operation: .cacheRemove,
            description: "Remove item from disk cache"
        )
        span?.setData(key: "key", value: key.rawValue)

        cache.removeValue(forKey: key)
        let fileURL = fileURL(forKey: key)
        try? FileManager.default.removeItem(at: fileURL)

        Self.logger.debug("DISK CACHE REMOVE: \(key.rawValue, privacy: .public)")
        span?.finish()
    }

    func flush() async {
        let span = SpanContext.startChild(
            operation: .cacheFlush,
            description: "Flush disk cache"
        )

        cache = [:]
        try? FileManager.default.removeItem(at: directoryURL)
        Self.createDirectoryIfNeeded(at: directoryURL)

        Self.logger.debug("DISK CACHE FLUSH")
        span?.finish()
    }

}

extension DiskCache {

    private func fileURL(forKey key: CacheKey) -> URL {
        let safeFilename = key.rawValue
            .addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key.rawValue
        return directoryURL.appendingPathComponent(safeFilename)
    }

    private static func createDirectoryIfNeeded(at url: URL) {
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

}
