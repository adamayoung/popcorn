//
//  TVSeriesProviding.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol TVSeriesProviding: Sendable {

    func tvSeries(withID id: Int) async throws(TVSeriesProviderError) -> TVSeries
}

public enum TVSeriesProviderError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
