//
//  CacheItem.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

struct CacheItem<Item> {

    var value: Item? {
        guard !isExpired else {
            return nil
        }

        return internalValue
    }

    var isExpired: Bool {
        guard let expiresAt else {
            return false
        }

        return expiresAt < Date()
    }

    private let expiresAt: Date?
    private let internalValue: Item

    init(value: Item, expiresIn: TimeInterval? = nil) {
        self.internalValue = value
        self.expiresAt = {
            guard let expiresIn else {
                return nil
            }

            return Date().addingTimeInterval(expiresIn)
        }()
    }

}
