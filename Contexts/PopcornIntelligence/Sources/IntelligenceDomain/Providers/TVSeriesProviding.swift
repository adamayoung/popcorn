//
//  TVSeriesProviding.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Defines the ``TVSeriesProviding`` contract.
public protocol TVSeriesProviding: Sendable {

    func tvSeries(withID id: Int) async throws(TVSeriesProviderError) -> TVSeries
}

/// Represents the ``TVSeriesProviderError`` values.
public enum TVSeriesProviderError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
