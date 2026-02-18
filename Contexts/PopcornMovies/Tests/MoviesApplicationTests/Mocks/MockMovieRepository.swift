//
//  MockMovieRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

final class MockMovieRepository: MovieRepository, @unchecked Sendable {

    var movieCallCount = 0
    var movieCalledWith: [Int] = []
    var movieStubs: [Int: Result<Movie, MovieRepositoryError>] = [:]

    var certificationCallCount = 0
    var certificationCalledWith: [Int] = []
    var certificationStub: Result<String, MovieRepositoryError>?

    func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie {
        movieCallCount += 1
        movieCalledWith.append(id)

        guard let stub = movieStubs[id] else {
            throw .notFound
        }

        switch stub {
        case .success(let movie):
            return movie
        case .failure(let error):
            throw error
        }
    }

    func movieStream(withID id: Int) async -> AsyncThrowingStream<Movie?, Error> {
        AsyncThrowingStream { _ in }
    }

    func certification(forMovie movieID: Int) async throws(MovieRepositoryError) -> String {
        certificationCallCount += 1
        certificationCalledWith.append(movieID)

        guard let stub = certificationStub else {
            throw .notFound
        }

        switch stub {
        case .success(let certification):
            return certification
        case .failure(let error):
            throw error
        }
    }

}
