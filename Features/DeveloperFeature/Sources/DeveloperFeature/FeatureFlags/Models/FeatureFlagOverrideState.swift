//
//  FeatureFlagOverrideState.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public enum FeatureFlagOverrideState: Equatable, Sendable {

    case `default`
    case enabled
    case disabled

}

extension FeatureFlagOverrideState {

    var value: Bool? {
        switch self {
        case .default: nil
        case .enabled: true
        case .disabled: false
        }
    }

    init(value: Bool?) {
        switch value {
        case nil:
            self = .default
        case true:
            self = .enabled
        case false:
            self = .disabled
        }
    }

}
