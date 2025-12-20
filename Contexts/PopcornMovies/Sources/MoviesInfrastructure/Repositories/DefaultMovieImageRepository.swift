//
//  DefaultMovieImageRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

final class DefaultMovieImageRepository: MovieImageRepository {

    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any MovieImageLocalDataSource

    init(
        remoteDataSource: some MovieRemoteDataSource,
        localDataSource: any MovieImageLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieImageRepositoryError) -> ImageCollection {
        do {
            if let cachedImageCollection = try await localDataSource.imageCollection(
                forMovie: movieID) {
                return cachedImageCollection
            }
        } catch let error {
            throw MovieImageRepositoryError(error)
        }

        let imageCollection: ImageCollection
        do {
            imageCollection = try await remoteDataSource.imageCollection(forMovie: movieID)
        } catch let error {
            throw MovieImageRepositoryError(error)
        }

        do { try await localDataSource.setImageCollection(imageCollection) } catch let error {
            throw MovieImageRepositoryError(error)
        }

        return imageCollection
    }

    func imageCollectionStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<ImageCollection?, Error> {
        let stream = await localDataSource.imageCollectionStream(forMovie: movieID)

        Task {
            if try await localDataSource.imageCollection(forMovie: movieID) == nil {
                let imageCollection = try await remoteDataSource.imageCollection(forMovie: movieID)
                try await localDataSource.setImageCollection(imageCollection)
            }
        }

        return stream
    }

}

extension MovieImageRepositoryError {

    init(_ error: MovieImageLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: MovieRemoteDataSourceError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
