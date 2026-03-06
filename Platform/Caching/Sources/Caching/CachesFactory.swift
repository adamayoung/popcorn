//
//  CachesFactory.swift
//  Caching
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct CachesFactory {

    private init() {}

    public static func makeInMemoryCache(defaultExpiresIn: TimeInterval = 60 * 60) -> some Caching {
        InMemoryCache(defaultExpiresIn: defaultExpiresIn)
    }

    public static func makeDiskCache(
        subdirectory: String,
        defaultExpiresIn: TimeInterval = 7 * 24 * 60 * 60
    ) -> some Caching {
        DiskCache(subdirectory: subdirectory, defaultExpiresIn: defaultExpiresIn)
    }

}
