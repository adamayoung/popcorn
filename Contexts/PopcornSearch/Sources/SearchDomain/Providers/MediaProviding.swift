//
//  MediaProviding.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol MediaProviding: Sendable {

    func movie(withID id: Int) async throws(MediaProviderError) -> MoviePreview

    func tvSeries(withID id: Int) async throws(MediaProviderError) -> TVSeriesPreview

    func person(withID id: Int) async throws(MediaProviderError) -> PersonPreview

}

public enum MediaProviderError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
