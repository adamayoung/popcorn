//
//  CachesFactory.swift
//  Caching
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct CachesFactory {

    private init() {}

    public static func makeInMemoryCache(defaultExpiresIn: TimeInterval = 60 * 60) -> some Caching {
        InMemoryCache(defaultExpiresIn: defaultExpiresIn)
    }

}
