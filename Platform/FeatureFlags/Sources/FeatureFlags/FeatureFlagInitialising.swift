//
//  FeatureFlagInitialising.swift
//  FeatureFlags
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public protocol FeatureFlagInitialising: Sendable {

    func start(_ config: FeatureFlagsConfiguration) async throws

}
