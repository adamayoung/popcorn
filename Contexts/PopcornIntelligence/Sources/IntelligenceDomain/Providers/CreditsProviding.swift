//
//  CreditsProviding.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Defines the ``CreditsProviding`` contract.
public protocol CreditsProviding: Sendable {

    func credits(forMovie movieID: Int) async throws(CreditsProviderError) -> Credits

//    func credits(forTVSeries tvSeriesID: Int) async throws(CreditsProviderError) -> Credits

}

/// Represents the ``CreditsProviderError`` values.
public enum CreditsProviderError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
