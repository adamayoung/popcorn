//
//  PeopleInfrastructureFactory.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Caching
import Foundation
import PeopleDomain

package final class PeopleInfrastructureFactory {

    private static let cache: some Caching = CachesFactory.makeInMemoryCache(defaultExpiresIn: 60)

    private let personRemoteDataSource: any PersonRemoteDataSource

    package init(personRemoteDataSource: some PersonRemoteDataSource) {
        self.personRemoteDataSource = personRemoteDataSource
    }

    package func makePersonRepository() -> some PersonRepository {
        let localDataSource = makePersonLocalDataSource()
        return DefaultPersonRepository(
            remoteDataSource: personRemoteDataSource,
            localDataSource: localDataSource
        )
    }

}

extension PeopleInfrastructureFactory {

    private func makePersonLocalDataSource() -> some PersonLocalDataSource {
        let cache = makeCache()
        return CachedPersonLocalDataSource(cache: cache)
    }

}

extension PeopleInfrastructureFactory {

    private func makeCache() -> some Caching {
        Self.cache
    }

}
