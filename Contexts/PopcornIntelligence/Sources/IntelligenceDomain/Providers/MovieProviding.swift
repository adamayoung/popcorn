//
//  MovieProviding.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Defines the ``MovieProviding`` contract.
public protocol MovieProviding: Sendable {

    func movie(withID id: Int) async throws(MovieProviderError) -> Movie
}

/// Represents the ``MovieProviderError`` values.
public enum MovieProviderError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
