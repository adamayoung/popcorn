//
//  CachedConfigurationLocalDataSourceTests.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import Caching
import CachingTestHelpers
@testable import ConfigurationInfrastructure
import CoreDomain
import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing

@Suite("CachedConfigurationLocalDataSource")
struct CachedConfigurationLocalDataSourceTests {

    let mockCache: MockCache
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockCache = MockCache()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    @Test("configuration returns nil when cache is empty")
    func configurationReturnsNilWhenCacheIsEmpty() async {
        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        let result = await dataSource.configuration()

        #expect(result == nil)
        #expect(await mockCache.itemCallCount == 1)
    }

    @Test("configuration returns cached value when available")
    func configurationReturnsCachedValueWhenAvailable() async {
        let expectedConfiguration = AppConfiguration.mock()
        await mockCache.setItem(expectedConfiguration, forKey: .appConfiguration)

        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        let result = await dataSource.configuration()

        #expect(result != nil)
    }

    @Test("configuration uses correct cache key")
    func configurationUsesCorrectCacheKey() async {
        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        _ = await dataSource.configuration()

        let calledKeys = await mockCache.itemCalledWithKeys
        #expect(calledKeys.count == 1)
        #expect(calledKeys[0] == .appConfiguration)
    }

    @Test("configuration requests correct type from cache")
    func configurationRequestsCorrectTypeFromCache() async {
        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        _ = await dataSource.configuration()

        let calledTypes = await mockCache.itemCalledWithTypes
        #expect(calledTypes.count == 1)
        #expect(calledTypes[0] == "AppConfiguration")
    }

    @Test("setConfiguration stores value in cache")
    func setConfigurationStoresValueInCache() async {
        let configuration = AppConfiguration.mock()

        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        await dataSource.setConfiguration(configuration)

        #expect(await mockCache.setItemCallCount == 1)
        #expect(await mockCache.setItemCalledWithKeys.contains(.appConfiguration))
    }

    @Test("setConfiguration allows retrieval of stored value")
    func setConfigurationAllowsRetrievalOfStoredValue() async {
        let configuration = AppConfiguration.mock()

        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        await dataSource.setConfiguration(configuration)
        let result = await dataSource.configuration()

        #expect(result != nil)
    }

    @Test("configuration creates span with correct operation")
    func configurationCreatesSpanWithCorrectOperation() async {
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        _ = await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.configuration()
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value == SpanOperation.localDataSourceGet.value
        )
        #expect(mockSpan.startChildCalledWith[0].description == "Get App Configuration")
    }

    @Test("configuration finishes span")
    func configurationFinishesSpan() async {
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        _ = await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.configuration()
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    @Test("setConfiguration creates span with correct operation")
    func setConfigurationCreatesSpanWithCorrectOperation() async {
        let configuration = AppConfiguration.mock()
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.setConfiguration(configuration)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value == SpanOperation.localDataSourceSet.value
        )
        #expect(mockSpan.startChildCalledWith[0].description == "Set App Configuration")
    }

    @Test("setConfiguration finishes span")
    func setConfigurationFinishesSpan() async {
        let configuration = AppConfiguration.mock()
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.setConfiguration(configuration)
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    @Test("configuration works without span")
    func configurationWorksWithoutSpan() async {
        SpanContext.provider = nil

        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        let result = await dataSource.configuration()

        #expect(result == nil)
        #expect(await mockCache.itemCallCount == 1)
    }

    @Test("setConfiguration works without span")
    func setConfigurationWorksWithoutSpan() async {
        let configuration = AppConfiguration.mock()
        SpanContext.provider = nil

        let dataSource = CachedConfigurationLocalDataSource(cache: mockCache)

        await dataSource.setConfiguration(configuration)

        #expect(await mockCache.setItemCallCount == 1)
    }

}
