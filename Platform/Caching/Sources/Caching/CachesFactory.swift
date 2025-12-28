//
//  CachesFactory.swift
//  Caching
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A factory for creating cache instances.
///
/// Use this factory to create configured cache implementations.
///
public struct CachesFactory {

    private init() {}

    ///
    /// Creates an in-memory cache with the specified default expiration time.
    ///
    /// - Parameter defaultExpiresIn: The default time interval after which
    ///   cached items expire. Defaults to 1 hour (3600 seconds).
    /// - Returns: A new in-memory cache instance conforming to ``Caching``.
    ///
    public static func makeInMemoryCache(defaultExpiresIn: TimeInterval = 60 * 60) -> some Caching {
        InMemoryCache(defaultExpiresIn: defaultExpiresIn)
    }

}
