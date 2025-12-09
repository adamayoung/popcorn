//
//  MovieLogoImageProviding.swift
//  PopcornDiscover
//
//  Created by Adam Young on 24/11/2025.
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
