//
//  FeatureFlagProviding.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol FeatureFlagProviding: Sendable {

    var isInitialized: Bool { get }

    func start(_ config: FeatureFlagsConfiguration) async throws

    func isEnabled(_ key: String) -> Bool

}
