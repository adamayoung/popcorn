//
//  MockFeatureFlags.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
import Foundation

///
/// A mock implementation of ``FeatureFlagging`` and ``FeatureFlagInitialising`` for use in unit tests.
///
/// This mock tracks all method calls and their arguments, allowing tests to
/// verify feature flag service interactions.
///
public final class MockFeatureFlags: FeatureFlagging, FeatureFlagInitialising, @unchecked Sendable {

    /// A Boolean value indicating whether the service has been initialized.
    public var isInitialised: Bool

    /// The number of times ``start(_:)`` has been called.
    public var startCallCount = 0

    /// The configurations passed to ``start(_:)`` calls.
    public private(set) var startCalledWith: [FeatureFlagsConfiguration] = []

    /// An error to throw when ``start(_:)`` is called.
    public var startError: Error?

    /// The number of times either ``isEnabled(_:)`` overload has been called.
    public var isEnabledCallCount = 0

    /// The feature flags passed to ``isEnabled(_:)-7vhab`` calls.
    public private(set) var isEnabledCalledWithFlags: [FeatureFlag] = []

    /// The string keys passed to ``isEnabled(_:)-9vhk6`` calls.
    public private(set) var isEnabledCalledWithKeys: [String] = []

    /// The set of feature flags that should return `true` when checked.
    public var enabledFlags: Set<FeatureFlag>

    /// The set of string keys that should return `true` when checked.
    public var enabledKeys: Set<String>

    /// A custom closure for determining if a feature flag is enabled.
    public var isEnabledFlagStub: ((FeatureFlag) -> Bool)?

    /// A custom closure for determining if a string key is enabled.
    public var isEnabledKeyStub: ((String) -> Bool)?

    ///
    /// Creates a new mock feature flags instance.
    ///
    /// - Parameters:
    ///   - isInitialised: The initial initialization state. Defaults to `false`.
    ///   - enabledFlags: The set of flags that should be enabled. Defaults to empty.
    ///   - enabledKeys: The set of keys that should be enabled. Defaults to empty.
    ///
    public init(
        isInitialised: Bool = false,
        enabledFlags: Set<FeatureFlag> = [],
        enabledKeys: Set<String> = []
    ) {
        self.isInitialised = isInitialised
        self.enabledFlags = enabledFlags
        self.enabledKeys = enabledKeys
    }

    public func start(_ config: FeatureFlagsConfiguration) async throws {
        startCallCount += 1
        startCalledWith.append(config)

        if let startError {
            throw startError
        }

        isInitialised = true
    }

    public func isEnabled(_ flag: FeatureFlag) -> Bool {
        isEnabledCallCount += 1
        isEnabledCalledWithFlags.append(flag)

        if let isEnabledFlagStub {
            return isEnabledFlagStub(flag)
        }

        if enabledFlags.contains(flag) {
            return true
        }

        return enabledKeys.contains(flag.rawValue)
    }

    public func isEnabled(_ key: some StringProtocol) -> Bool {
        let key = key.description
        isEnabledCallCount += 1
        isEnabledCalledWithKeys.append(key)

        if let isEnabledKeyStub {
            return isEnabledKeyStub(key)
        }

        return enabledKeys.contains(key)
    }

    ///
    /// Resets the mock to its initial state.
    ///
    /// Clears all call counts, recorded arguments, and configured stubs.
    ///
    public func reset() {
        startCallCount = 0
        startCalledWith.removeAll()
        startError = nil
        isEnabledCallCount = 0
        isEnabledCalledWithFlags.removeAll()
        isEnabledCalledWithKeys.removeAll()
        enabledFlags.removeAll()
        enabledKeys.removeAll()
        isEnabledFlagStub = nil
        isEnabledKeyStub = nil
        isInitialised = false
    }

}
