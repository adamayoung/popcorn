//
//  MockFeatureFlagProvider.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
import Foundation

public final class MockFeatureFlagProvider: FeatureFlagProviding, @unchecked Sendable {

    public var isInitialized: Bool

    public private(set) var startCallCount = 0
    public private(set) var startCalledWith: [FeatureFlagsConfiguration] = []
    public var startError: Error?

    public var isEnabledCallCount = 0
    public private(set) var isEnabledCalledWithKeys: [String] = []

    public var enabledKeys: Set<String>
    public var isEnabledStub: ((String) -> Bool)?

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
