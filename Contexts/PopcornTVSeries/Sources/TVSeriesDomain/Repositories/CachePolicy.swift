//
//  CachePolicy.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the caching strategy for repository fetch operations.
///
/// Use this enum to control how repositories handle cached data when fetching.
///
public enum CachePolicy: Sendable {

    /// Check cache first; if unavailable or expired, fetch from network and update cache.
    case cacheFirst

    /// Always fetch from network, ignoring any cached data. Updates the cache with fresh data.
    case networkOnly

    /// Only return cached data. Throws an error if no cached data is available.
    case cacheOnly

}
