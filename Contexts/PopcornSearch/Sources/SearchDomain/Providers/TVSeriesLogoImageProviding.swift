//
//  TVSeriesLogoImageProviding.swift
//  PopcornSearch
//
//  Created by Adam Young on 24/11/2025.
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
