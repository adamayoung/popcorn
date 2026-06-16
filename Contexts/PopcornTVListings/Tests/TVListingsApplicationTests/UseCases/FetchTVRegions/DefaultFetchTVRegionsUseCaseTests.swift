//
//  DefaultFetchTVRegionsUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultFetchTVRegionsUseCase")
struct DefaultFetchTVRegionsUseCaseTests {

    let mockRepository = MockTVRegionRepository()

    @Test("execute returns regions on success")
    func executeReturnsRegionsOnSuccess() async throws {
        let regions = [
            TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)
        ]
        mockRepository.regionsStub = .success(regions)

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result == regions)
        #expect(mockRepository.regionsCallCount == 1)
    }

    @Test("execute throws local when repository throws local")
    func executeThrowsLocalWhenRepositoryThrowsLocal() async {
        mockRepository.regionsStub = .failure(.local(nil))

        let useCase = makeUseCase()

        await #expect(
            performing: { _ = try await useCase.execute() },
            throws: { isError($0, .local) }
        )
    }

    @Test("execute throws unknown when repository throws remote or unknown")
    func executeThrowsUnknownWhenRepositoryThrowsRemoteOrUnknown() async {
        for repositoryError: TVListingsRepositoryError in [.remote(nil), .unknown(nil)] {
            mockRepository.regionsStub = .failure(repositoryError)

            let useCase = makeUseCase()

            await #expect(
                performing: { _ = try await useCase.execute() },
                throws: { isError($0, .unknown) }
            )
        }
    }

    private func makeUseCase() -> DefaultFetchTVRegionsUseCase {
        DefaultFetchTVRegionsUseCase(tvRegionRepository: mockRepository)
    }

    private enum ErrorKind { case local, unknown }

    private func isError(_ error: any Error, _ kind: ErrorKind) -> Bool {
        guard let error = error as? FetchTVRegionsError else {
            return false
        }
        switch (error, kind) {
        case (.local, .local), (.unknown, .unknown): return true
        default: return false
        }
    }

}
