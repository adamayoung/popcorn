//
//  DeveloperFeatureTests.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
@testable import DeveloperFeature
import Testing

@MainActor
@Suite("DeveloperFeature Tests")
struct DeveloperFeatureTests {

    @Test("pushing featureFlags path element adds to stack")
    func pushingFeatureFlagsAddsToStack() async {
        let store = TestStore(
            initialState: DeveloperFeature.State()
        ) {
            DeveloperFeature()
        }

        await store.send(\.path.push, (id: 0, state: .featureFlags(FeatureFlagsFeature.State()))) {
            $0.path[id: 0] = .featureFlags(FeatureFlagsFeature.State())
        }
    }

    @Test("popping path element removes from stack")
    func poppingPathRemovesFromStack() async {
        var initialState = DeveloperFeature.State()
        initialState.path[id: 0] = .featureFlags(FeatureFlagsFeature.State())

        let store = TestStore(
            initialState: initialState
        ) {
            DeveloperFeature()
        }

        await store.send(\.path.popFrom, 0) {
            $0.path = StackState<DeveloperFeature.Path.State>()
        }
    }

}
