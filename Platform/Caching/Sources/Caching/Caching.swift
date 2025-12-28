//
//  Caching.swift
//  Caching
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A protocol defining an actor-based cache for storing and retrieving items.
///
/// Conforming types provide thread-safe caching operations with optional
/// expiration support.
///
public protocol Caching: Actor {

    /// The number of items currently stored in the cache.
    var count: Int { get async }

    /// A Boolean value indicating whether the cache is empty.
    var isEmpty: Bool { get async }

    ///
    /// Retrieves an item from the cache for the specified key.
    ///
    /// - Parameters:
    ///   - key: The key identifying the cached item.
    ///   - type: The expected type of the cached item.
    /// - Returns: The cached item if found and not expired, otherwise `nil`.
    ///
    func item<Item>(forKey key: CacheKey, ofType type: Item.Type) async -> Item?

    ///
    /// Stores an item in the cache with the default expiration time.
    ///
    /// - Parameters:
    ///   - item: The item to cache.
    ///   - key: The key to associate with the cached item.
    ///
    func setItem(_ item: some Any, forKey key: CacheKey) async

    ///
    /// Stores an item in the cache with a custom expiration time.
    ///
    /// - Parameters:
    ///   - item: The item to cache.
    ///   - key: The key to associate with the cached item.
    ///   - expiresIn: The time interval after which the item expires.
    ///
    func setItem(_ item: some Any, forKey key: CacheKey, expiresIn: TimeInterval) async

    ///
    /// Removes an item from the cache for the specified key.
    ///
    /// - Parameter key: The key identifying the item to remove.
    ///
    func removeItem(forKey key: CacheKey) async

    ///
    /// Removes all items from the cache.
    ///
    func flush() async

}

///
/// A type-safe key for identifying cached items.
///
/// Use `CacheKey` to create unique identifiers for cached data. The key wraps
/// a raw string value and provides hashable, sendable semantics.
///
public struct CacheKey: Hashable, Sendable, RawRepresentable {

    public typealias RawValue = String

    /// The underlying string value of the cache key.
    public let rawValue: String

    ///
    /// Creates a cache key with the specified string value.
    ///
    /// - Parameter rawValue: The string value for the cache key.
    ///
    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }

    ///
    /// Creates a cache key with the specified raw value.
    ///
    /// - Parameter rawValue: The string value for the cache key.
    ///
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

}
