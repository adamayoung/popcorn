//
//  MovieRemoteDataSource.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

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

    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRemoteDataSourceError) -> [MoviePreview]

    func credits(forMovie movieID: Int) async throws(MovieRemoteDataSourceError) -> Credits

    func certification(forMovie movieID: Int) async throws(MovieRemoteDataSourceError) -> String

}

public enum MovieRemoteDataSourceError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
