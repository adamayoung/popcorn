//
//  MockCache.swift
//  Caching
//
//  Copyright © 2025 Adam Young.
//

import Caching
import Foundation

///
/// A mock implementation of ``Caching`` for use in unit tests.
///
/// This mock tracks all method calls and their arguments, allowing tests to
/// verify caching behavior without using a real cache implementation.
///
public actor MockCache: Caching, @unchecked Sendable {

    private var storage: [CacheKey: Any] = [:]

    /// The number of times ``item(forKey:ofType:)`` has been called.
    public var itemCallCount = 0

    /// The keys passed to ``item(forKey:ofType:)`` calls.
    public private(set) var itemCalledWithKeys: [CacheKey] = []

    /// The type names passed to ``item(forKey:ofType:)`` calls.
    public private(set) var itemCalledWithTypes: [String] = []

    /// The number of times ``setItem(_:forKey:)`` has been called.
    public var setItemCallCount = 0

    /// The keys passed to ``setItem(_:forKey:)`` calls.
    public private(set) var setItemCalledWithKeys: [CacheKey] = []

    /// The number of times ``setItem(_:forKey:expiresIn:)`` has been called.
    public var setItemWithExpiryCallCount = 0

    /// The keys passed to ``setItem(_:forKey:expiresIn:)`` calls.
    public private(set) var setItemWithExpiryCalledWithKeys: [CacheKey] = []

    /// The number of times ``removeItem(forKey:)`` has been called.
    public var removeItemCallCount = 0

    /// The keys passed to ``removeItem(forKey:)`` calls.
    public private(set) var removeItemCalledWithKeys: [CacheKey] = []

    /// The number of times ``flush()`` has been called.
    public var flushCallCount = 0

    /// Creates a new mock cache instance.
    public init() {}

    public var count: Int {
        storage.count
    }

    public var isEmpty: Bool {
        storage.isEmpty
    }

    public func item<Item>(forKey key: CacheKey, ofType type: Item.Type) -> Item? {
        itemCallCount += 1
        itemCalledWithKeys.append(key)
        itemCalledWithTypes.append(String(describing: type))
        return storage[key] as? Item
    }

    public func setItem(_ item: some Any, forKey key: CacheKey) {
        setItemCallCount += 1
        setItemCalledWithKeys.append(key)
        storage[key] = item
    }

    public func setItem(_ item: some Any, forKey key: CacheKey, expiresIn: TimeInterval) {
        setItemWithExpiryCallCount += 1
        setItemWithExpiryCalledWithKeys.append(key)
        storage[key] = item
    }

    public func removeItem(forKey key: CacheKey) {
        removeItemCallCount += 1
        removeItemCalledWithKeys.append(key)
        storage.removeValue(forKey: key)
    }

    public func flush() {
        flushCallCount += 1
        storage.removeAll()
    }

}
