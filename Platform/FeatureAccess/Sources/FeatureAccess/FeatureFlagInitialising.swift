//
//  FeatureFlagInitialising.swift
//  FeatureAccess
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FeatureFlagInitialising: Sendable {

    func start(_ config: FeatureFlagsConfiguration) async throws

}
