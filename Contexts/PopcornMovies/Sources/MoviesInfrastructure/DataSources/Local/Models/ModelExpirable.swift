//
//  ModelExpirable.swift
//  PopcornMovies
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation

protocol ModelExpirable {

    var cachedAt: Date { get }

}

extension ModelExpirable {

    func isExpired(ttl: TimeInterval) -> Bool {
        let age = max(0, Date().timeIntervalSince(cachedAt))
        return age > ttl
    }

}
