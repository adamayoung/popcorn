//
//  MockCache.swift
//  Caching
//
//  Copyright © 2025 Adam Young.
//

import Caching
import Foundation

public actor MockCache: Caching, @unchecked Sendable {

    private var storage: [CacheKey: Any] = [:]

    public var itemCallCount = 0
    public private(set) var itemCalledWithKeys: [CacheKey] = []
    public private(set) var itemCalledWithTypes: [String] = []

    public var setItemCallCount = 0
    public private(set) var setItemCalledWithKeys: [CacheKey] = []

    public var setItemWithExpiryCallCount = 0
    public private(set) var setItemWithExpiryCalledWithKeys: [CacheKey] = []

    public var removeItemCallCount = 0
    public private(set) var removeItemCalledWithKeys: [CacheKey] = []

    public var flushCallCount = 0

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
