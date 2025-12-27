//
//  MovieProviding.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol MovieProviding: Sendable {

    func movie(withID id: Int) async throws(MovieProviderError) -> Movie
}

public enum MovieProviderError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
