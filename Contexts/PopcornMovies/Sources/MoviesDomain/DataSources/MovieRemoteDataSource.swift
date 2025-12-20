//
//  MovieRemoteDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol MovieRemoteDataSource: Sendable {

    func movie(withID id: Int) async throws(MovieRemoteDataSourceError) -> Movie

    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieRemoteDataSourceError) -> ImageCollection

    func popular(page: Int) async throws(MovieRemoteDataSourceError) -> [MoviePreview]

    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(MovieRemoteDataSourceError) -> [MoviePreview]

}

public enum MovieRemoteDataSourceError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
