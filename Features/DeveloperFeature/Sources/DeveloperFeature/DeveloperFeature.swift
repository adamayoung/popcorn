//
//  DeveloperFeature.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct DeveloperFeature {

    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()

        public init() {}
    }

    @Reducer
    public enum Path {
        case featureFlags(FeatureFlagsFeature)
    }

    public enum Action {
        case path(StackActionOf<Path>)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { _, action in
            switch action {
            case .path:
                .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension DeveloperFeature.Path.State: Equatable {}
