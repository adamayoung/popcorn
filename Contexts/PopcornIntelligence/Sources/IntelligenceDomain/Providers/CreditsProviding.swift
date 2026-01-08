//
//  CreditsProviding.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol CreditsProviding: Sendable {

    func credits(forMovie movieID: Int) async throws(CreditsProviderError) -> Credits

//    func credits(forTVSeries tvSeriesID: Int) async throws(CreditsProviderError) -> Credits

}

public enum CreditsProviderError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
