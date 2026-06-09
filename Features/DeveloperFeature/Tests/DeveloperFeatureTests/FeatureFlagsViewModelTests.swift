//
//  FeatureFlagsViewModelTests.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

@testable import DeveloperFeature
import Foundation
import Presentation
import Synchronization
import Testing

@Suite("FeatureFlagsViewModel Tests")
struct FeatureFlagsViewModelTests {

    // MARK: - load

    @Test("load transitions to loading then ready on success")
    @MainActor
    func loadSuccessSetsReady() async {
        let featureFlags = [Self.testFlag]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchFeatureFlags: { featureFlags })
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(.init(featureFlags: featureFlags)))
    }

    @Test("load sets viewState to error on failure")
    @MainActor
    func loadFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchFeatureFlags: { throw TestError.fetchFailed })
        )

        await viewModel.load()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.fetchFailed)))
    }

    @Test("load when already ready reloads feature flags")
    @MainActor
    func loadWhenReadyReloads() async {
        let updatedFlags = [Self.updatedTestFlag]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchFeatureFlags: { updatedFlags }),
            viewState: .ready(.init(featureFlags: []))
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(.init(featureFlags: updatedFlags)))
    }

    // MARK: - setFeatureFlagOverride

    @Test("setFeatureFlagOverride with enabled calls dependency with true and refetches")
    @MainActor
    func setOverrideEnabledCallsDependencyWithTrue() async {
        let receivedValue = Mutex<Bool?>(nil)
        let updatedFlags = [Self.updatedTestFlag]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchFeatureFlags: { updatedFlags },
                updateFeatureFlagValue: { _, value in receivedValue.withLock { $0 = value } }
            )
        )

        await viewModel.setFeatureFlagOverride(Self.testFlag, .enabled)

        #expect(receivedValue.withLock { $0 } == true)
        #expect(viewModel.viewState == .ready(.init(featureFlags: updatedFlags)))
    }

    @Test("setFeatureFlagOverride with disabled calls dependency with false and refetches")
    @MainActor
    func setOverrideDisabledCallsDependencyWithFalse() async {
        let receivedValue = Mutex<Bool?>(nil)
        let updatedFlags = [Self.testFlag]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchFeatureFlags: { updatedFlags },
                updateFeatureFlagValue: { _, value in receivedValue.withLock { $0 = value } }
            )
        )

        await viewModel.setFeatureFlagOverride(Self.testFlag, .disabled)

        #expect(receivedValue.withLock { $0 } == false)
        #expect(viewModel.viewState == .ready(.init(featureFlags: updatedFlags)))
    }

    @Test("setFeatureFlagOverride with default calls dependency with nil and refetches")
    @MainActor
    func setOverrideDefaultCallsDependencyWithNil() async {
        let receivedValue = Mutex<Bool?>(nil)
        let wasCalled = Mutex(false)
        let updatedFlags = [Self.testFlag]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchFeatureFlags: { updatedFlags },
                updateFeatureFlagValue: { _, value in
                    wasCalled.withLock { $0 = true }
                    receivedValue.withLock { $0 = value }
                }
            )
        )

        await viewModel.setFeatureFlagOverride(Self.testFlag, .default)

        #expect(wasCalled.withLock { $0 } == true)
        #expect(receivedValue.withLock { $0 } == nil)
        #expect(viewModel.viewState == .ready(.init(featureFlags: updatedFlags)))
    }

    // MARK: - resetAllOverrides

    @Test("resetAllOverrides calls removeAllOverrides and refetches flags")
    @MainActor
    func resetAllOverridesCallsRemoveAllOverridesAndRefetches() async {
        let removeAllCalled = Mutex(false)
        let flags = [Self.testFlag]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchFeatureFlags: { flags },
                removeAllOverrides: { removeAllCalled.withLock { $0 = true } }
            )
        )

        await viewModel.resetAllOverrides()

        #expect(removeAllCalled.withLock { $0 } == true)
        #expect(viewModel.viewState == .ready(.init(featureFlags: flags)))
    }

}

// MARK: - Test Helpers

extension FeatureFlagsViewModelTests {

    static let testFlag = FeatureFlag(
        id: "test_flag",
        name: "Test Flag",
        description: "A test flag",
        value: true,
        override: .default
    )

    static let updatedTestFlag = FeatureFlag(
        id: "test_flag",
        name: "Test Flag",
        description: "A test flag",
        value: true,
        override: .enabled
    )

    @MainActor
    static func makeViewModel(
        dependencies: FeatureFlagsDependencies = stubDependencies(),
        viewState: ViewState<FeatureFlagsViewModel.ViewSnapshot> = .initial
    ) -> FeatureFlagsViewModel {
        FeatureFlagsViewModel(dependencies: dependencies, viewState: viewState)
    }

    static func stubDependencies(
        fetchFeatureFlags: @escaping @Sendable () async throws -> [FeatureFlag] = { [] },
        updateFeatureFlagValue: @escaping @Sendable (FeatureFlag, Bool?) -> Void = { _, _ in },
        removeAllOverrides: @escaping @Sendable () -> Void = {}
    ) -> FeatureFlagsDependencies {
        FeatureFlagsDependencies(
            fetchFeatureFlags: fetchFeatureFlags,
            updateFeatureFlagValue: updateFeatureFlagValue,
            removeAllOverrides: removeAllOverrides
        )
    }

}

private enum TestError: Error {
    case fetchFailed
}
