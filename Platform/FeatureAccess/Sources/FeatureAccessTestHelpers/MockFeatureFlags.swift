//
//  MockFeatureFlags.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
import Foundation

public final class MockFeatureFlags: FeatureFlagging, FeatureFlagInitialising, @unchecked Sendable {

    public var isInitialised: Bool

    public var startCallCount = 0
    public private(set) var startCalledWith: [FeatureFlagsConfiguration] = []
    public var startError: Error?

    public var isEnabledCallCount = 0
    public private(set) var isEnabledCalledWithFlags: [FeatureFlag] = []
    public private(set) var isEnabledCalledWithKeys: [String] = []

    public var enabledFlags: Set<FeatureFlag>
    public var enabledKeys: Set<String>

    public var isEnabledFlagStub: ((FeatureFlag) -> Bool)?
    public var isEnabledKeyStub: ((String) -> Bool)?

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
