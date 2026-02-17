//
//  MockMovieLogoImageProvider.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

final class MockMovieLogoImageProvider: MovieLogoImageProviding, @unchecked Sendable {

    var imageURLSetCallCount = 0
    var imageURLSetCalledWith: [Int] = []
    var imageURLSetStub: Result<ImageURLSet?, MovieLogoImageProviderError>?
    var imageURLSetStubByID: [Int: Result<ImageURLSet?, MovieLogoImageProviderError>] = [:]

    func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError) -> ImageURLSet? {
        imageURLSetCallCount += 1
        imageURLSetCalledWith.append(movieID)

        if let stubByID = imageURLSetStubByID[movieID] {
            switch stubByID {
            case .success(let urlSet):
                return urlSet
            case .failure(let error):
                throw error
            }
        }

        guard let stub = imageURLSetStub else {
            return nil
        }

        switch stub {
        case .success(let urlSet):
            return urlSet
        case .failure(let error):
            throw error
        }
    }

}
