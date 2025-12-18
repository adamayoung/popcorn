//
//  CachesFactory.swift
//  Caching
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation

public struct CachesFactory {

    private init() {}

    public static func makeInMemoryCache(defaultExpiresIn: TimeInterval = 60 * 60) -> some Caching {
        InMemoryCache(defaultExpiresIn: defaultExpiresIn)
    }

}
