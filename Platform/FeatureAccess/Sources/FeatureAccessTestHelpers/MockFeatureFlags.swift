//
//  MockFeatureFlags.swift
//  FeatureAccess
//
//  Copyright © 2026 Adam Young.
//

import FeatureAccess
import Foundation

public final class MockFeatureFlags: FeatureFlagging, FeatureFlagOverriding, FeatureFlagInitialising,
@unchecked Sendable {

    public var isInitialised: Bool

    public var startCallCount = 0
    public private(set) var startCalledWith: [FeatureFlagsConfiguration] = []
    public var startError: Error?

    public var isEnabledCallCount = 0
    public private(set) var isEnabledCalledWithFlags: [FeatureFlag] = []

    public var enabledFlags: Set<FeatureFlag>
    public var enabledKeys: Set<String>

    public var isEnabledFlagStub: ((FeatureFlag) -> Bool)?

    public var actualValueCallCount = 0
    public private(set) var actualValueCalledWithFlags: [FeatureFlag] = []
    public var actualValueStub: ((FeatureFlag) -> Bool)?

    public var setOverrideValueCallCount = 0
    public private(set) var setOverrideValueCalledWith: [(Bool, FeatureFlag)] = []

    public var overrideValueCallCount = 0
    public private(set) var overrideValueCalledWithFlags: [FeatureFlag] = []
    public var overrideValueStub: ((FeatureFlag) -> Bool?)?

    public var removeOverrideCallCount = 0
    public private(set) var removeOverrideCalledWithFlags: [FeatureFlag] = []

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

        return enabledKeys.contains(flag.id)
    }

    public func actualValue(for flag: FeatureFlag) -> Bool {
        actualValueCallCount += 1
        actualValueCalledWithFlags.append(flag)

        if let actualValueStub {
            return actualValueStub(flag)
        }

        if enabledFlags.contains(flag) {
            return true
        }

        return enabledKeys.contains(flag.id)
    }

    public func setOverrideValue(_ value: Bool, for flag: FeatureFlag) {
        setOverrideValueCallCount += 1
        setOverrideValueCalledWith.append((value, flag))
    }

    public func overrideValue(for flag: FeatureFlag) -> Bool? {
        overrideValueCallCount += 1
        overrideValueCalledWithFlags.append(flag)

        if let overrideValueStub {
            return overrideValueStub(flag)
        }

        return nil
    }

    public func removeOverride(for flag: FeatureFlag) {
        removeOverrideCallCount += 1
        removeOverrideCalledWithFlags.append(flag)
    }

    public var removeAllOverridesCallCount = 0

    public func removeAllOverrides() {
        removeAllOverridesCallCount += 1
    }

    public func reset() {
        startCallCount = 0
        startCalledWith.removeAll()
        startError = nil
        isEnabledCallCount = 0
        isEnabledCalledWithFlags.removeAll()
        enabledFlags.removeAll()
        enabledKeys.removeAll()
        isEnabledFlagStub = nil
        actualValueCallCount = 0
        actualValueCalledWithFlags.removeAll()
        actualValueStub = nil
        setOverrideValueCallCount = 0
        setOverrideValueCalledWith.removeAll()
        overrideValueCallCount = 0
        overrideValueCalledWithFlags.removeAll()
        overrideValueStub = nil
        removeOverrideCallCount = 0
        removeOverrideCalledWithFlags.removeAll()
        removeAllOverridesCallCount = 0
        isInitialised = false
    }

}
