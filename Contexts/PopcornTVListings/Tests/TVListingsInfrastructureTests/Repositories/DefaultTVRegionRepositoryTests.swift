//
//  DefaultTVRegionRepositoryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("DefaultTVRegionRepository")
struct DefaultTVRegionRepositoryTests {

    @Test("regions returns local data source result")
    func regionsReturnsLocalDataSourceResult() async throws {
        let mockLocal = MockTVListingsLocalDataSource()
        let expected = [TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)]
        await mockLocal.setRegionsStub(.success(expected))

        let repository = DefaultTVRegionRepository(localDataSource: mockLocal)

        let result = try await repository.regions()

        #expect(result == expected)
    }

    @Test("regions translates persistence error to local")
    func regionsTranslatesPersistenceErrorToLocal() async {
        let mockLocal = MockTVListingsLocalDataSource()
        await mockLocal.setRegionsStub(.failure(.persistence(NSError(domain: "test", code: 1))))

        let repository = DefaultTVRegionRepository(localDataSource: mockLocal)

        await #expect(
            performing: { _ = try await repository.regions() },
            throws: { error in
                guard let repoError = error as? TVListingsRepositoryError, case .local = repoError else {
                    return false
                }
                return true
            }
        )
    }

}

extension MockTVListingsLocalDataSource {

    func setRegionsStub(_ value: Result<[TVRegion], TVListingsLocalDataSourceError>) {
        regionsStub = value
    }

}
