//
//  DefaultThemeColorProviderTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Caching
import CachingTestHelpers
import CoreDomain
import Foundation
import Testing
@testable import ThemeColorProvider

@Suite("DefaultThemeColorProvider")
struct DefaultThemeColorProviderTests {

    @Test("cache key derived from URL filename without extension")
    func cacheKeyDerivedFromURLFilename() throws {
        let url = try #require(URL(string: "https://image.tmdb.org/t/p/w185/abc123.jpg"))

        let key = DefaultThemeColorProvider.cacheKey(for: url)

        #expect(key == "abc123")
    }

    @Test("cache hit returns cached ThemeColor without downloading")
    func cacheHitReturnsCachedThemeColor() async throws {
        let url = try #require(URL(string: "https://image.tmdb.org/t/p/w185/poster123.jpg"))
        let expectedColor = ThemeColor(red: 0.5, green: 0.3, blue: 0.8)
        let cache = MockCache()
        await cache.setItem(expectedColor, forKey: CacheKey("poster123"))

        let provider = DefaultThemeColorProvider(cache: cache)
        let result = await provider.themeColor(for: url)

        #expect(result == expectedColor)
    }

}
