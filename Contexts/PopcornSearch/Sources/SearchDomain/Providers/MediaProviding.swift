//
//  MediaProviding.swift
//  PopcornSearch
//
//  Created by Adam Young on 04/12/2025.
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
