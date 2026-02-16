//
//  FeatureFlagServiceTests.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

@testable import FeatureAccess
import FeatureAccessTestHelpers
import Foundation
import Testing

@Suite("FeatureFlagService Tests")
struct FeatureFlagServiceTests {

    private let provider: MockFeatureFlagProvider
    private let userDefaults: UserDefaults
    private let service: FeatureFlagService

    init() throws {
        let suiteName = "FeatureFlagServiceTests.\(UUID().uuidString)"
        self.provider = MockFeatureFlagProvider()
        self.userDefaults = try #require(UserDefaults(suiteName: suiteName))
        userDefaults.removePersistentDomain(forName: suiteName)
        self.service = FeatureFlagService(featureFlagProvider: provider, userDefaults: userDefaults)
    }

    // MARK: - isInitialised

    @Test("isInitialised returns false when provider is not initialised")
    func isInitialisedReturnsFalseWhenProviderNotInitialised() {
        provider.isInitialized = false

        #expect(service.isInitialised == false)
    }

    @Test("isInitialised returns true when provider is initialised")
    func isInitialisedReturnsTrueWhenProviderInitialised() {
        provider.isInitialized = true

        #expect(service.isInitialised == true)
    }

    // MARK: - start

    @Test("start forwards config to provider")
    func startForwardsConfigToProvider() async throws {
        let config = FeatureFlagsConfiguration(
            apiKey: "test-key",
            environment: .development,
            userID: "test-user"
        )

        try await service.start(config)

        #expect(provider.startCallCount == 1)
        #expect(provider.startCalledWith.first?.apiKey == "test-key")
        #expect(provider.startCalledWith.first?.userID == "test-user")
    }

    @Test("start throws when provider throws")
    func startThrowsWhenProviderThrows() async {
        provider.startError = TestError.providerFailed
        let config = FeatureFlagsConfiguration(
            apiKey: "test-key",
            environment: .development,
            userID: "test-user"
        )

        await #expect(throws: TestError.self) {
            try await service.start(config)
        }
    }

    // MARK: - isEnabled

    @Test("isEnabled returns provider value when no override exists")
    func isEnabledReturnsProviderValueWhenNoOverride() {
        provider.enabledKeys = [FeatureFlag.explore.id]

        #expect(service.isEnabled(.explore) == true)
        #expect(service.isEnabled(.games) == false)
    }

    @Test("isEnabled returns override value when override is set")
    func isEnabledReturnsOverrideValueWhenOverrideSet() {
        provider.enabledKeys = []
        service.setOverrideValue(true, for: .explore)

        #expect(service.isEnabled(.explore) == true)
    }

    @Test("isEnabled returns false override even when provider returns true")
    func isEnabledReturnsFalseOverrideEvenWhenProviderReturnsTrue() {
        provider.enabledKeys = [FeatureFlag.explore.id]
        service.setOverrideValue(false, for: .explore)

        #expect(service.isEnabled(.explore) == false)
    }

    // MARK: - actualValue

    @Test("actualValue always returns provider value ignoring overrides")
    func actualValueReturnsProviderValueIgnoringOverrides() {
        provider.enabledKeys = [FeatureFlag.explore.id]
        service.setOverrideValue(false, for: .explore)

        #expect(service.actualValue(for: .explore) == true)
    }

    // MARK: - setOverrideValue / overrideValue

    @Test("setOverrideValue stores value in UserDefaults")
    func setOverrideValueStoresInUserDefaults() {
        service.setOverrideValue(true, for: .games)

        let key = "featureFlagOverride.\(FeatureFlag.games.id)"
        #expect(userDefaults.object(forKey: key) != nil)
        #expect(userDefaults.bool(forKey: key) == true)
    }

    @Test("overrideValue returns nil when no override set")
    func overrideValueReturnsNilWhenNoOverrideSet() {
        #expect(service.overrideValue(for: .explore) == nil)
    }

    @Test("overrideValue returns stored value")
    func overrideValueReturnsStoredValue() {
        service.setOverrideValue(true, for: .explore)
        #expect(service.overrideValue(for: .explore) == true)

        service.setOverrideValue(false, for: .games)
        #expect(service.overrideValue(for: .games) == false)
    }

    // MARK: - removeOverride

    @Test("removeOverride clears the UserDefaults entry")
    func removeOverrideClearsUserDefaultsEntry() {
        service.setOverrideValue(true, for: .explore)
        #expect(service.overrideValue(for: .explore) == true)

        service.removeOverride(for: .explore)
        #expect(service.overrideValue(for: .explore) == nil)
    }

}

// MARK: - Test Helpers

private enum TestError: Error {
    case providerFailed
}
