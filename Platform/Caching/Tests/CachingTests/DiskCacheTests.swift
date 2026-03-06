//
//  DiskCacheTests.swift
//  Caching
//
//  Copyright © 2026 Adam Young.
//

@testable import Caching
import Foundation
import Testing

@Suite("DiskCache", .serialized)
struct DiskCacheTests {

    private let subdirectory: String

    init() {
        self.subdirectory = "DiskCacheTests-\(UUID().uuidString)"
    }

    @Test("cache miss returns nil")
    func cacheMissReturnsNil() async {
        let cache = makeCache()

        let result: String? = await cache.item(forKey: CacheKey("missing"), ofType: String.self)

        #expect(result == nil)
    }

    @Test("set and get round-trip for Codable type")
    func setAndGetRoundTrip() async {
        let cache = makeCache()

        await cache.setItem("hello", forKey: CacheKey("greeting"))
        let result: String? = await cache.item(forKey: CacheKey("greeting"), ofType: String.self)

        #expect(result == "hello")
    }

    @Test("persistence across cache instances")
    func persistenceAcrossCacheInstances() async {
        let cache1 = makeCache()
        await cache1.setItem("persisted", forKey: CacheKey("key"))

        let cache2 = makeCache()
        let result: String? = await cache2.item(forKey: CacheKey("key"), ofType: String.self)

        #expect(result == "persisted")
        await cache1.flush()
    }

    @Test("TTL expiry returns nil")
    func ttlExpiryReturnsNil() async {
        let cache = DiskCache(subdirectory: subdirectory, defaultExpiresIn: 0.001)

        await cache.setItem("expiring", forKey: CacheKey("key"))
        try? await Task.sleep(for: .milliseconds(10))
        let result: String? = await cache.item(forKey: CacheKey("key"), ofType: String.self)

        #expect(result == nil)
        await cache.flush()
    }

    @Test("flush clears memory and disk")
    func flushClearsMemoryAndDisk() async {
        let cache = makeCache()
        await cache.setItem("value", forKey: CacheKey("key"))
        await cache.flush()

        let result: String? = await cache.item(forKey: CacheKey("key"), ofType: String.self)
        let isEmpty = await cache.isEmpty

        #expect(result == nil)
        #expect(isEmpty)
    }

    @Test("removeItem removes from both layers")
    func removeItemRemovesFromBothLayers() async {
        let cache = makeCache()
        await cache.setItem("value", forKey: CacheKey("key"))
        await cache.removeItem(forKey: CacheKey("key"))

        let result: String? = await cache.item(forKey: CacheKey("key"), ofType: String.self)

        #expect(result == nil)

        let cache2 = makeCache()
        let diskResult: String? = await cache2.item(forKey: CacheKey("key"), ofType: String.self)
        #expect(diskResult == nil)

        await cache.flush()
    }

    @Test("corrupted JSON file on disk returns nil")
    func corruptedJSONFileReturnsNil() async {
        let cache = makeCache()

        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let dirURL = cachesDirectory.appendingPathComponent(subdirectory, isDirectory: true)
        let safeFilename = "corrupt".addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "corrupt"
        let fileURL = dirURL.appendingPathComponent(safeFilename)
        try? Data("not valid json{{{".utf8).write(to: fileURL, options: .atomic)

        let result: String? = await cache.item(forKey: CacheKey("corrupt"), ofType: String.self)

        #expect(result == nil)
        await cache.flush()
    }

    @Test("Codable struct round-trip")
    func codableStructRoundTrip() async {
        let cache = makeCache()
        let value = TestCodableItem(name: "test", value: 42)

        await cache.setItem(value, forKey: CacheKey("struct"))
        let result: TestCodableItem? = await cache.item(
            forKey: CacheKey("struct"),
            ofType: TestCodableItem.self
        )

        #expect(result == value)
        await cache.flush()
    }

    @Test("count reflects stored items")
    func countReflectsStoredItems() async {
        let cache = makeCache()

        await cache.setItem("a", forKey: CacheKey("1"))
        await cache.setItem("b", forKey: CacheKey("2"))

        let count = await cache.count

        #expect(count == 2)
        await cache.flush()
    }

}

extension DiskCacheTests {

    private func makeCache() -> DiskCache {
        DiskCache(subdirectory: subdirectory)
    }

}

private struct TestCodableItem: Codable, Equatable {
    let name: String
    let value: Int
}
