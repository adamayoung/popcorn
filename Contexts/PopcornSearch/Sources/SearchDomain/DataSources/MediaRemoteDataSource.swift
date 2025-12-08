//
//  MediaRemoteDataSource.swift
//  PopcornSearch
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation

public protocol MediaRemoteDataSource: Sendable {

    func search(query: String, page: Int) async throws(MediaRemoteDataSourceError) -> [MediaPreview]

}

public enum MediaRemoteDataSourceError: Error {

    case unauthorised
    case unknown(Error?)

}
