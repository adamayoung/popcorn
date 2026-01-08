//
//  DefaultConfigurationRepositoryTests.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import CoreDomain
import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing

@testable import ConfigurationInfrastructure

@Suite("DefaultConfigurationRepository")
struct DefaultConfigurationRepositoryTests {

    let mockRemoteDataSource: MockConfigurationRemoteDataSource
    let mockLocalDataSource: MockConfigurationLocalDataSource
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRemoteDataSource = MockConfigurationRemoteDataSource()
        self.mockLocalDataSource = MockConfigurationLocalDataSource()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    @Test("configuration returns cached value when available")
    func configurationReturnsCachedValueWhenAvailable() async throws {
        let cachedConfiguration = AppConfiguration.mock()
        mockLocalDataSource.configurationStub = cachedConfiguration

        let repository = DefaultConfigurationRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await repository.configuration()

        #expect(await mockLocalDataSource.configurationCallCount == 1)
        #expect(mockRemoteDataSource.configurationCallCount == 0)
    }

    @Test("configuration fetches from remote when cache is empty")
    func configurationFetchesFromRemoteWhenCacheIsEmpty() async throws {
        let remoteConfiguration = AppConfiguration.mock()
        mockLocalDataSource.configurationStub = nil
        mockRemoteDataSource.configurationStub = .success(remoteConfiguration)

        let repository = DefaultConfigurationRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await repository.configuration()

        #expect(await mockLocalDataSource.configurationCallCount == 1)
        #expect(mockRemoteDataSource.configurationCallCount == 1)
    }

    @Test("configuration caches remote value after fetching")
    func configurationCachesRemoteValueAfterFetching() async throws {
        let remoteConfiguration = AppConfiguration.mock()
        mockLocalDataSource.configurationStub = nil
        mockRemoteDataSource.configurationStub = .success(remoteConfiguration)

        let repository = DefaultConfigurationRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await repository.configuration()

        #expect(await mockLocalDataSource.setConfigurationCallCount == 1)
        #expect(await mockLocalDataSource.setConfigurationCalledWith.count == 1)
    }

    @Test("configuration throws error when remote fails")
    func configurationThrowsErrorWhenRemoteFails() async throws {
        mockLocalDataSource.configurationStub = nil
        mockRemoteDataSource.configurationStub = .failure(.unauthorised)

        let repository = DefaultConfigurationRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await repository.configuration()
            },
            throws: { error in
                guard let repoError = error as? ConfigurationRepositoryError else {
                    return false
                }
                if case .unauthorised = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("configuration creates span with correct operation")
    func configurationCreatesSpanWithCorrectOperation() async throws {
        let cachedConfiguration = AppConfiguration.mock()
        let mockSpan = MockSpan()

        mockLocalDataSource.configurationStub = cachedConfiguration
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultConfigurationRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.configuration()
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(mockSpan.startChildCalledWith[0].operation.value == SpanOperation.repositoryGet.value)
        #expect(mockSpan.startChildCalledWith[0].description == "Fetch App Configuration")
    }

    @Test("configuration sets cache hit data on span when cached")
    func configurationSetsCacheHitDataOnSpanWhenCached() async throws {
        let cachedConfiguration = AppConfiguration.mock()
        let mockSpan = MockSpan()

        mockLocalDataSource.configurationStub = cachedConfiguration
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultConfigurationRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.configuration()
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "cache.hit" })
        #expect(cacheHitEntry != nil)
        #expect(cacheHitEntry?.value == "true")
    }

    @Test("configuration sets cache miss data on span when not cached")
    func configurationSetsCacheMissDataOnSpanWhenNotCached() async throws {
        let remoteConfiguration = AppConfiguration.mock()
        let mockSpan = MockSpan()

        mockLocalDataSource.configurationStub = nil
        mockRemoteDataSource.configurationStub = .success(remoteConfiguration)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultConfigurationRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.configuration()
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "cache.hit" })
        #expect(cacheHitEntry != nil)
        #expect(cacheHitEntry?.value == "false")
    }

    @Test("configuration finishes span on success")
    func configurationFinishesSpanOnSuccess() async throws {
        let cachedConfiguration = AppConfiguration.mock()
        let mockSpan = MockSpan()

        mockLocalDataSource.configurationStub = cachedConfiguration
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultConfigurationRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.configuration()
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    @Test("configuration works without span")
    func configurationWorksWithoutSpan() async throws {
        let cachedConfiguration = AppConfiguration.mock()
        mockLocalDataSource.configurationStub = cachedConfiguration

        SpanContext.provider = nil

        let repository = DefaultConfigurationRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await repository.configuration()

        #expect(await mockLocalDataSource.configurationCallCount == 1)
    }

}
