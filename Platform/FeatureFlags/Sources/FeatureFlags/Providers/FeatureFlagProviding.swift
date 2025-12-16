//
//  FeatureFlagProviding.swift
//  FeatureFlags
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation

public protocol FeatureFlagProviding: Sendable {

    func start(_ config: FeatureFlagsConfiguration) async throws

    func isEnabled(_ key: String) -> Bool

}
