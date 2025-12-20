//
//  MediaRemoteDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol MediaRemoteDataSource: Sendable {

    func search(query: String, page: Int) async throws(MediaRemoteDataSourceError) -> [MediaPreview]

}

public enum MediaRemoteDataSourceError: Error {

    case unauthorised
    case unknown(Error?)

}
