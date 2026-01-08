//
//  MediaRemoteDataSource.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain

public protocol MediaRemoteDataSource: Sendable {

    func search(query: String, page: Int) async throws(MediaRemoteDataSourceError) -> [MediaPreview]

}

public enum MediaRemoteDataSourceError: Error {

    case unauthorised
    case unknown(Error?)

}
