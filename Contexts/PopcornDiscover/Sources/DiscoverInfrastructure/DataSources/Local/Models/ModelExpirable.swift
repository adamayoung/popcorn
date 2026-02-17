//
//  ModelExpirable.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
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
