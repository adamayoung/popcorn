//
//  FeatureFlag.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct FeatureFlag: Equatable, Sendable, Identifiable {

    public let id: String
    public let name: String
    public let description: String
    public let value: Bool
    public let override: FeatureFlagOverrideState
    public var isEnabled: Bool {
        switch override {
        case .default: value
        case .enabled: true
        case .disabled: false
        }
    }

    public init(
        id: String,
        name: String,
        description: String,
        value: Bool,
        override: FeatureFlagOverrideState
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.value = value
        self.override = override
    }

}

extension FeatureFlag {

    static var mocks: [FeatureFlag] {
        [
            FeatureFlag(
                id: "feature_flag_1",
                name: "Feature Flag 1",
                description: "Description of Feature Flag 1",
                value: true,
                override: .default
            ),
            FeatureFlag(
                id: "feature_flag_2",
                name: "Feature Flag 2",
                description: "Description of Feature Flag 2",
                value: false,
                override: .default
            ),
            FeatureFlag(
                id: "feature_flag_3",
                name: "Feature Flag 3",
                description: "Description of Feature Flag 3",
                value: true,
                override: .enabled
            ),
            FeatureFlag(
                id: "feature_flag_4",
                name: "Feature Flag 4",
                description: "Description of Feature Flag 4",
                value: false,
                override: .disabled
            ),
            FeatureFlag(
                id: "feature_flag_5",
                name: "Feature Flag 5",
                description: "Description of Feature Flag 5",
                value: true,
                override: .disabled
            ),
            FeatureFlag(
                id: "feature_flag_6",
                name: "Feature Flag 6",
                description: "Description of Feature Flag 6",
                value: false,
                override: .disabled
            )
        ]
    }

}
