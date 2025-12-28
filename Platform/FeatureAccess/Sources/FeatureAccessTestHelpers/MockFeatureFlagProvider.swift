//
//  MockFeatureFlagProvider.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
import Foundation

///
/// A mock implementation of ``FeatureFlagProviding`` for use in unit tests.
///
/// This mock tracks all method calls and their arguments, allowing tests to
/// verify feature flag provider interactions.
///
public final class MockFeatureFlagProvider: FeatureFlagProviding, @unchecked Sendable {

    /// A Boolean value indicating whether the provider has been initialized.
    public var isInitialized: Bool

    /// The number of times ``start(_:)`` has been called.
    public private(set) var startCallCount = 0

    /// The configurations passed to ``start(_:)`` calls.
    public private(set) var startCalledWith: [FeatureFlagsConfiguration] = []

    /// An error to throw when ``start(_:)`` is called.
    public var startError: Error?

    /// The number of times ``isEnabled(_:)`` has been called.
    public var isEnabledCallCount = 0

    /// The keys passed to ``isEnabled(_:)`` calls.
    public private(set) var isEnabledCalledWithKeys: [String] = []

    /// The set of feature flag keys that should return `true` when checked.
    public var enabledKeys: Set<String>

    /// A custom closure for determining if a feature flag is enabled.
    public var isEnabledStub: ((String) -> Bool)?

    ///
    /// Creates a new mock feature flag provider.
    ///
    /// - Parameters:
    ///   - isInitialized: The initial initialization state. Defaults to `false`.
    ///   - enabledKeys: The set of keys that should be enabled. Defaults to empty.
    ///
    public init(
        isInitialized: Bool = false,
        enabledKeys: Set<String> = []
    ) {
        self.isInitialized = isInitialized
        self.enabledKeys = enabledKeys
    }

    public func start(_ config: FeatureFlagsConfiguration) async throws {
        startCallCount += 1
        startCalledWith.append(config)

        if let startError {
            throw startError
        }

        isInitialized = true
    }

    public func isEnabled(_ key: String) -> Bool {
        isEnabledCallCount += 1
        isEnabledCalledWithKeys.append(key)

        if let isEnabledStub {
            return isEnabledStub(key)
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
        isEnabledCalledWithKeys.removeAll()
        enabledKeys.removeAll()
        isEnabledStub = nil
        isInitialized = false
    }

}
