//
//  TVSeriesLogoImageProviding.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public protocol TVSeriesLogoImageProviding: Sendable {

    func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError)
        -> ImageURLSet?

}

public enum TVSeriesLogoImageProviderError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
