//
//  DefaultThemeColorProvider.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Caching
import CoreDomain
import Foundation

/// Default implementation of ``ThemeColorProviding`` that downloads poster thumbnails,
/// extracts the average color, and caches the result to disk.
public final class DefaultThemeColorProvider: ThemeColorProviding, @unchecked Sendable {

    private let cache: any Caching
    private let urlSession: URLSession

    /// Creates a new theme color provider.
    ///
    /// - Parameters:
    ///   - cache: The cache to use for storing extracted theme colors.
    ///   - urlSession: The URL session to use for downloading poster thumbnails.
    public init(cache: some Caching, urlSession: URLSession = .shared) {
        self.cache = cache
        self.urlSession = urlSession
    }

    public func themeColor(for posterThumbnailURL: URL) async -> ThemeColor? {
        let cacheKey = CacheKey(Self.cacheKey(for: posterThumbnailURL))

        if let cached: ThemeColor = await cache.item(forKey: cacheKey, ofType: ThemeColor.self) {
            return cached
        }

        guard let data = try? await urlSession.data(from: posterThumbnailURL).0 else {
            return nil
        }

        guard let themeColor = ImageAverageColorExtractor.averageColor(from: data) else {
            return nil
        }

        await cache.setItem(themeColor, forKey: cacheKey)
        return themeColor
    }

}

extension DefaultThemeColorProvider {

    static func cacheKey(for url: URL) -> String {
        url.deletingPathExtension().lastPathComponent
    }

}
