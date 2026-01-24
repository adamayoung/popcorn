//
//  MockMovieRemoteDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure

final class MockMovieRemoteDataSource: MovieRemoteDataSource, @unchecked Sendable {

    var movieCallCount = 0
    var movieCalledWith: [Int] = []
    var movieStub: Result<Movie, MovieRemoteDataSourceError>?

    func movie(withID id: Int) async throws(MovieRemoteDataSourceError) -> Movie {
        movieCallCount += 1
        movieCalledWith.append(id)

        guard let stub = movieStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movie):
            return movie
        case .failure(let error):
            throw error
        }
    }

    var imageCollectionCallCount = 0
    var imageCollectionCalledWith: [Int] = []
    var imageCollectionStub: Result<ImageCollection, MovieRemoteDataSourceError>?

    func imageCollection(forMovie movieID: Int) async throws(MovieRemoteDataSourceError) -> ImageCollection {
        imageCollectionCallCount += 1
        imageCollectionCalledWith.append(movieID)

        guard let stub = imageCollectionStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let imageCollection):
            return imageCollection
        case .failure(let error):
            throw error
        }
    }

    var popularCallCount = 0
    var popularCalledWith: [Int] = []
    var popularStub: Result<[MoviePreview], MovieRemoteDataSourceError>?

    func popular(page: Int) async throws(MovieRemoteDataSourceError) -> [MoviePreview] {
        popularCallCount += 1
        popularCalledWith.append(page)

        guard let stub = popularStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    var similarCallCount = 0
    var similarCalledWith: [(movieID: Int, page: Int)] = []
    var similarStub: Result<[MoviePreview], MovieRemoteDataSourceError>?

    func similar(toMovie movieID: Int, page: Int) async throws(MovieRemoteDataSourceError) -> [MoviePreview] {
        similarCallCount += 1
        similarCalledWith.append((movieID: movieID, page: page))

        guard let stub = similarStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    var recommendationsCallCount = 0
    var recommendationsCalledWith: [(movieID: Int, page: Int)] = []
    var recommendationsStub: Result<[MoviePreview], MovieRemoteDataSourceError>?

    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRemoteDataSourceError) -> [MoviePreview] {
        recommendationsCallCount += 1
        recommendationsCalledWith.append((movieID: movieID, page: page))

        guard let stub = recommendationsStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    var creditsCallCount = 0
    var creditsCalledWith: [Int] = []
    var creditsStub: Result<Credits, MovieRemoteDataSourceError>?

    func credits(forMovie movieID: Int) async throws(MovieRemoteDataSourceError) -> Credits {
        creditsCallCount += 1
        creditsCalledWith.append(movieID)

        guard let stub = creditsStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    var certificationCallCount = 0
    var certificationCalledWith: [Int] = []
    var certificationStub: Result<String, MovieRemoteDataSourceError>?

    func certification(forMovie movieID: Int) async throws(MovieRemoteDataSourceError) -> String {
        certificationCallCount += 1
        certificationCalledWith.append(movieID)

        guard let stub = certificationStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let certification):
            return certification
        case .failure(let error):
            throw error
        }
    }

}
