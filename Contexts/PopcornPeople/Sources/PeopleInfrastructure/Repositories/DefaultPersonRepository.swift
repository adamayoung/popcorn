//
//  DefaultPersonRepository.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleDomain

final class DefaultPersonRepository: PersonRepository {

    private let remoteDataSource: any PersonRemoteDataSource
    private let localDataSource: any PersonLocalDataSource

    init(
        remoteDataSource: some PersonRemoteDataSource,
        localDataSource: some PersonLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func person(
        withID id: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(PersonRepositoryError) -> PeopleDomain.Person {
        switch cachePolicy {
        case .cacheFirst:
            if let cachedPerson = await localDataSource.person(withID: id) {
                return cachedPerson
            }

            let person = try await remoteDataSource.person(withID: id)
            await localDataSource.setPerson(person)
            return person

        case .networkOnly:
            let person = try await remoteDataSource.person(withID: id)
            await localDataSource.setPerson(person)
            return person

        case .cacheOnly:
            if let cachedPerson = await localDataSource.person(withID: id) {
                return cachedPerson
            }

            throw .cacheUnavailable
        }
    }

}
