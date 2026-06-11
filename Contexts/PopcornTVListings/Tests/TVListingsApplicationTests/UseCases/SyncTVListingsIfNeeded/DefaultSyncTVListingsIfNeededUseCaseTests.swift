//
//  DefaultSyncTVListingsIfNeededUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultSyncTVListingsIfNeededUseCase")
struct DefaultSyncTVListingsIfNeededUseCaseTests {

    let mockSyncRepository = MockTVListingsSyncRepository()

    @Test("execute delegates to syncIfNeeded once on success")
    func executeDelegatesToSyncIfNeededOnceOnSuccess() async throws {
        mockSyncRepository.syncIfNeededStub = .success(())

        let useCase = makeUseCase()

        try await useCase.execute()

        #expect(mockSyncRepository.syncIfNeededCallCount == 1)
    }

    @Test("execute throws remote when repository throws remote")
    func executeThrowsRemoteWhenRepositoryThrowsRemote() async {
        let underlying = NSError(domain: "test", code: 1)
        mockSyncRepository.syncIfNeededStub = .failure(.remote(underlying))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let syncError = error as? SyncTVListingsError else {
                    return false
                }
                if case .remote = syncError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws local when repository throws local")
    func executeThrowsLocalWhenRepositoryThrowsLocal() async {
        mockSyncRepository.syncIfNeededStub = .failure(.local(nil))

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
        mockSyncRepository.syncIfNeededStub = .failure(.unknown(nil))

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

    private func makeUseCase() -> DefaultSyncTVListingsIfNeededUseCase {
        DefaultSyncTVListingsIfNeededUseCase(tvListingsSyncRepository: mockSyncRepository)
    }

}
