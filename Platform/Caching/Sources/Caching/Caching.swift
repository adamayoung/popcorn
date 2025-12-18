//
//  Caching.swift
//  Caching
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation

public protocol Caching: Actor {

    var count: Int { get async }

    var isEmpty: Bool { get async }

    func item<Item>(forKey key: CacheKey, ofType type: Item.Type) async -> Item?

    func setItem<Item>(_ item: Item, forKey key: CacheKey) async

    func setItem<Item>(_ item: Item, forKey key: CacheKey, expiresIn: TimeInterval?) async

    func removeItem(forKey key: CacheKey) async

    func flush() async

}

public struct CacheKey: Hashable, Sendable, RawRepresentable {

    public typealias RawValue = String

    public let rawValue: String

    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

}
