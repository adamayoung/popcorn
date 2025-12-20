//
//  FeatureFlagInitialising.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol FeatureFlagInitialising: Sendable {

    func start(_ config: FeatureFlagsConfiguration) async throws

}
