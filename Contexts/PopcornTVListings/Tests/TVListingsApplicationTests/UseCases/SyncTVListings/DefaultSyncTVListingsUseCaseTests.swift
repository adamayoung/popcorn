//
//  DefaultSyncTVListingsUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultSyncTVListingsUseCase")
struct DefaultSyncTVListingsUseCaseTests {

    let mockSyncRepository = MockTVListingsSyncRepository()

    @Test("execute calls sync repository once on success")
    func executeCallsSyncRepositoryOnceOnSuccess() async throws {
        mockSyncRepository.syncStub = .success(())

        let useCase = makeUseCase()

        try await useCase.execute()

        #expect(mockSyncRepository.syncCallCount == 1)
    }

    @Test("execute throws remote when repository throws remote")
    func executeThrowsRemoteWhenRepositoryThrowsRemote() async {
        let underlying = NSError(domain: "test", code: 1)
        mockSyncRepository.syncStub = .failure(.remote(underlying))

        let useCase = makeUseCase()

        await #expect(throws: SyncTVListingsError.self) {
            try await useCase.execute()
        }
    }

    @Test("execute throws local when repository throws local")
    func executeThrowsLocalWhenRepositoryThrowsLocal() async {
        mockSyncRepository.syncStub = .failure(.local(nil))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let syncError = error as? SyncTVListingsError else {
                    return false
                }
                if case .local = syncError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown when repository throws unknown")
    func executeThrowsUnknownWhenRepositoryThrowsUnknown() async {
        mockSyncRepository.syncStub = .failure(.unknown(nil))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let syncError = error as? SyncTVListingsError else {
                    return false
                }
                if case .unknown = syncError {
                    return true
                }
                return false
            }
        )
    }

    private func makeUseCase() -> DefaultSyncTVListingsUseCase {
        DefaultSyncTVListingsUseCase(tvListingsSyncRepository: mockSyncRepository)
    }

}
