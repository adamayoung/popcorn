//
//  MovieLogoImageProviding.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public protocol MovieLogoImageProviding: Sendable {

    func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError)
        -> ImageURLSet?

}

public enum MovieLogoImageProviderError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
